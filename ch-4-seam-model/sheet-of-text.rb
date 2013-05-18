class CAsyncSslRec
  def initialize
    return true if m_b_ssl_initialized

    m_smutex.unlock
    m_n_ssl_ref_count += 1

    m_b_ssl_initialized = true

    free_library(m_h_ssl_dll1)
    m_h_ssl_dll1 = 0

    free_library(m_h_ssl_dll2)
    m_h_ssl_dll2 = 0

    unless m_b_failure_sent
      m_b_failure_sent = true
      # Goal: test this async_ssl_rec_init method without actually calling this
      # post_receive_error method while testing but still call it in production.
      post_receive_error(SOCKET_CALLBACK, SSL_FAILURE)
    end

    create_library(m_h_ssl_dll1, 'syncesel1.dll')
    create_library(m_h_ssl_dll2, 'syncesel2.dll')

    init(m_h_ssl_dll1)
    init(m_h_ssl_dll2)

    return true
  end
end