Received: from sonic306-20.consmr.mail.ir2.yahoo.com (sonic306-20.consmr.mail.ir2.yahoo.com [77.238.176.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44D0A12C477
	for <linux-cifs@vger.kernel.org>; Tue,  2 Jul 2024 19:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=77.238.176.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719949045; cv=none; b=ReMT2LO54ubn1GLvUKsTm//ljnqhRmXScs7zldhBYLB5qaccwvRpWNd8zrqb9hAvsergHMTLV6BoVXxT9CJTEVxiSU/WupGXFUZULOOlD1OqporrzAiEcDaCznpfuTBmeY1nnljm90R0ONRXCXlL2hDeToDEfhBbIT68iajv8Vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719949045; c=relaxed/simple;
	bh=UqD4qDHgnkzXRUs6DXEIu0uJRGA4KZtvm5mf0XkHvl8=;
	h=Date:From:To:Message-ID:Subject:MIME-Version:Content-Type:
	 References; b=s0fHv3iJu+qExJqTCKJfniXUTJ0RRm9qkXscwgze9Pgdd6sYtSjc7PZ2ejeOsEhHQgt6QKKJy954RvtT0to3H6c7XMVCEI+d7U8/v0PJNcKeUhyMkVj57SahutjC1aWee/luVhOjsUSaa3maA64gzulvF1UKlDgBXbGusCHCFKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.co.uk; spf=pass smtp.mailfrom=yahoo.co.uk; dkim=pass (2048-bit key) header.d=yahoo.co.uk header.i=@yahoo.co.uk header.b=uZIqsjvl; arc=none smtp.client-ip=77.238.176.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yahoo.co.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.co.uk header.i=@yahoo.co.uk header.b="uZIqsjvl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.co.uk; s=s2048; t=1719949041; bh=UqD4qDHgnkzXRUs6DXEIu0uJRGA4KZtvm5mf0XkHvl8=; h=Date:From:To:Subject:References:From:Subject:Reply-To; b=uZIqsjvlXtEEjKJ08wCpqoovgspLgvIcYvD/S14OAmOX7vQsLbNrtessvBu5LBf/Qu6b1EImWI/0N6qUAEc8VutR8lZH2Bo4M2lrP3yBb7haF2dXk8y60ecRkpe9zDt6pyUdUYk4efb1eWzXUOgtxh8mwaJ3iiTTi+RgwBXWrElW3DjQptxo9ac7tOCYG7xu42bN/6EigywyCbfjKCMya8utIg2AXaOcB1rfBVgNYI0cztyHq1vqZzzKZXd9GhqOIL4CPLsAa0zTQq1ehH98UN/tWUZmXKxnz2Cme/o7CWwtR6bScbQncweZPEbwWzDGPo5F8aQp1gNzfjBTxcnZJg==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1719949041; bh=l1JGCiVnaW48hr0aQGyFIo2gI6GRxyS/UnKe5eunn9b=; h=X-Sonic-MF:Date:From:To:Subject:From:Subject; b=gKy+QI9Hzlz2fb3StQ3whacOcVs69lRBvlec4F35kmjvrnZ1iU8UZ2JscCuhlNo7fP9hA8FITTfPDeNy3+phUaJJcbDtqWmAj7iT2L8sNTa0rYRnwDYwEiG+Oj7KRGnYSDCi046qO7Q5d0bascsNSi8ESxkmooLNPaqImagLRzx9rIbAoQcm+5qGFcvjUrTT5E3XORYVV+/66ps5sidGjRWs/BQqdX2vwSw9LDN9tLEYJBZ1IH+DM5o7rEaeQYz9WV4uiF8jwqR84gPy2oLl8yNtxBDhySzm4jHU5yvYMwWxMSdyGa5NHEpv2XWeqXcMvegLggNHTGO5lLaPlqOgXw==
X-YMail-OSG: Ze_Jd1EVM1kzH6agKbg4qE13ZTD.gxSAgatEptszVsDeDWR3.qHs3QryQNUJNjk
 QAwukIkRxMVHK0fVWPci_wpbNN6ZCUZTn_1N5_77eFaVKnMXbJVj0Bf4oXcAZk.WIAjLWt3lbZk_
 IZycyCy42ieZ6ujEfls6mVq4poj5v08797rBdt68vplIdAelYt7wL486xRlLO.nIyKNLUdYQMgsg
 Y8Ixqv6j6wG76tAaQH7kOBUwYzaDyvHDcB6eajv.pGjnW50ieCp0SFHRz9Sp8WRmVn2WRHHZ_EaO
 F1XV1uXkJq3s5YYt2nIbTZ_BLHf6EXzZzirY62LrG9OYPSwLnUFA_RhJxw9BkCcTfNYVpPez_AVK
 Vkp_rNPSQ5y2GyokPuYeMxI0ahHMsqZHgrgmgJhioAFjaqNCTSQBQifDaTKF4Fs9.ZmwmfIq.U7k
 XcUwnbyzz0_zdR_BdRwD6gVCS7SUxPiMy0vbClDKFIyUyLmU_pvSnt6.12.OymVQAaFjzMgkj2LV
 p6PR.bO40rcjFdr72MyKpEvGA6BrVd4wHpAucHHGozI8EByWIks_r.D_qU0xVjVaRQ9MH4VgKrQr
 6ye9HV46Ls_o8gUjEkHiPnSabCZEF_CUL7ygRiDjv2KohZbKlKdbnjo4dFKnNCOFd8a96U8cL8kx
 ikqvxGt_7KmNe3wlYCQTNosMzBCVDK1z_ylyLeNdC9edtGze_v5kQtIVIS_zRDeTVTyXSIemHqr0
 BtE5osQ4Gak8ztwxBms3jpxZS4xIU6PaQ_WwpH0zvMAJCSPXG2uc_wiaDMXSjummvfr.cOL7yoaT
 yOjjYmJEuU2ULPwGLn8_jqZU6QFDj7U9iEvLlboskPdpnhgRplBw8967mptaF2IQqYUxhwX6fmA_
 yjywJPnDxsFUg3.3C2K_OCvSm4HzIvM3aWXjNl6I20ElGxiscom6uJHDtdE9.QkqgfQprCfEDXld
 abYEP8vo89PxH8IQ9_222Wpl00IrZ_firDpmhvWU7wn3EbcXdaqi9CQCWcGRthICi60AOme5CsJs
 BoiG9Nrb0ecqGxAAviUPq03LaVuS_d9BcDCJnXbPOMccpuDEqb9Cs4z7T6GoTWWC4S95NDqR9ptR
 XqgX2TSVTPrCAMDQXlpqGwXv.fEsexz1.mzSDml9uB5xuMBdinO9Z3HOlIJmkBJTZjpiijX7h4PQ
 .G0vXUIwV69SJjVBAxVpievJ9FqQVN_HWXHavym5QEJYfoEsU3JnFCNqfr3txxjV7952WR2k7XUj
 ereU20kqzUGNacxciuR0AqpDb8woMyUYRQagmnYYc3W1cmoXr0Yy1VFsPPyTdCki3gnjaP6lM83F
 tVlS9IM8sa0zmw3adgHnTC5pDE5yB1Y1Oe2TerNRM64YHbB8niricBj5ICgqppUJS_6ZfYgj0uKz
 d4k721ekUwQ5qT7R8N5K0JDXDzf5.qRRyBp76qMtdlsE0B.jI7dTSP3VwRnaEZXqo28U5wECVOMk
 lmGv.yREuBeGKx0hXrfBgTH79dVDbA8qe4tDN2ndhtlYU.AyPwBAGNa9qQFEorcz1467pQT0dXdd
 7WFlYyjPxnmHO4kEcx8VkTfnmMvA4VDVUuwbUtqzSeTX9lXCDI4_RQQxhWj2i4dspGfOzZAsF4kl
 2sxs_6Akq0F36F2SnV5DWN0fWDUpkkICM3vxHwvtCuM6E1eXbXQZym.9W1dk8D0.o9PpypNjiLUS
 UliofwMvK7OiDQ4K4X_KX1rJ.WSF8iybyMLC638822E52NWXxv.hx0aVoMpehVmY8wlyorWms.Nl
 kgTA4JXLuYbu2QT6dDWM2Xi48t3ZugNUKpNfXaQuSmqWHSEfvO1LuLuy7gyG6ODsamOasZcm27fm
 pj5DaK9sUaWlmoTZWmMrHjP.JdQ0kWEwXNlcUxSlYYHaVhCHxzlzP1Kfc2hTKTkMuoIliQCHpb6g
 S_IOR9XgMwO3I2_FWNB2lD5fzsSb7DMvWowIIPbjrRXO7wzqOj4VDaTAw4QUx7PqHv61lXVAcnnW
 Sv9pmdIAma0TeSCrn1Ud4e6BUimVV30RxW61Zfl6q6Zb8oZVX7ecohVZUXLahw7VClFr4Q9NgM.q
 q33cxkQOphRRu.PvYs74Z1v_yQEBR2nJ_CmGSV_o8SaV92nCkMoRXGxLOQdMSJSILfn0jBVyJhOW
 aDVm1T2Qx0eEHkR6GPgMAAWnOUjVVXKQLLOobXhqqh7KAK2E-
X-Sonic-MF: <jokiiii@yahoo.co.uk>
X-Sonic-ID: ba1d7e5d-e4fd-466a-a4a5-3a2e8d06de95
Received: from sonic.gate.mail.ne1.yahoo.com by sonic306.consmr.mail.ir2.yahoo.com with HTTP; Tue, 2 Jul 2024 19:37:21 +0000
Date: Tue, 2 Jul 2024 18:26:20 +0000 (UTC)
From: Jo King <jokiiii@yahoo.co.uk>
To: linux-cifs@vger.kernel.org
Message-ID: <317425567.302900.1719944780037@mail.yahoo.com>
Subject: cifs-utils depends on python - need it?
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <317425567.302900.1719944780037.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.22464 YMailNodin

Hi, i originally reported this to debian at:
https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1072991

Could the recently introduced smb2-quota be written without python?
..or re-homed or $some_other_solution ?
Ideally 'core' bin stuff (mount.cifs) would be installable on systems which do not have python.

Apologies for noticing this late (tend to stick on debian releases until end of support).

Thanks, jo

