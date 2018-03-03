def epsilon(w, wp, w0, gamma):
    """ Return the epsilon in a Lorentz Model
        with plasma frequencies wp, resonance
        frequencies w0 and damping constants gamma
    """
    eps_r = 1
    assert len(wp) == len(w0) == len(gamma)
    for i in range(len(wp)):
        eps_r += wp[i]**2 / (w0[i]**2 - w**2 - 1j*gamma[i]*w)
    return eps_r