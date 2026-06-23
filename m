Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F0883C4B89
	for <linux-cifs@vger.kernel.org>; Tue, 23 Jun 2026 07:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782199061; cv=none; b=Vm3WhX1QuK0iFpTZh5sa9sS6KFWMFNsAd9G++SAh9kuapjVLtvFGxaBz5if3atNaXxJtpWLXCk9SY17Z0uY/77Mus9Tk+SXdcqME73iyyYvxP1vSnt6qfg4/BhjwF8TnY6XV/D/h1LSa33GXsVb1yNsnTTHDwEA6Fi5e9R0gq/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782199061; c=relaxed/simple;
	bh=Oj7YVwlO/OaTkfORZ43yDdVXGIV+K1a+2nYVPgAarm4=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=d8uzNjPTQSjkbvfA0rCyP69fhQi3UjNuUqAUFRPdfQFkWlYsrsSSEAtPB/KD4sRvd+z/tiYzbNDBxNND/6dV5l18tw6olf9ARImVht0sOVoZC4vlypFzgO7AZOOiN1J6vif1pOWnObGU3Jt2Ie9Vur8wXtZHPdnJQCW+svvtC9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EoYK/VVL; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EoYK/VVL"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-bec43ee8ff0so106219166b.1
        for <linux-cifs@vger.kernel.org>; Tue, 23 Jun 2026 00:17:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782199056; x=1782803856; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=437zXLTxvpe8ACk+RUJ2xNH6l+BjBqxDV+xl8Qz3Gwg=;
        b=EoYK/VVLwzqFEAVuKs2O9ubNR3MMICIcjNvLsYhJuvLrNLnbtAEOAMb9L8tMWjzJKU
         23MdkSWtgw1BcbXNf1+NIJUK/12ZeAuzKNUDMqhG80ksBHHT4PHg3Dd3i4mTL/GTQM1K
         aFsa2x8dfVpqwgXURAdrJ0XpvcDU7plj+itA3Av1pB8JPZqzrL8kXzCF+gXBBOiu1fU/
         4aov/i5MwinewhZ0P8fLcAE7x1DvPhgdzv4/OMvuTh4iLwt2xOWWo0BjS0N7FkexbszK
         6eiFqTI8fQIzS56QUXRq1f8LjwUUj2Zrgd+snJ7N9OGR8wS+yKePB//hAovY0/QEtX5Q
         VKZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782199056; x=1782803856;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=437zXLTxvpe8ACk+RUJ2xNH6l+BjBqxDV+xl8Qz3Gwg=;
        b=DPpmut7AlJBcOPtwuJIyrzbjIKH8RIHU4WSfcHlsjWMAL0AMJhU2nVQpFT2RX7O2/U
         zyHl4Jk8Ca5HeDb4AeUPXdJOfMBkXm5MWd16KfrlRSVaFPBaS1ftu79hoID63xQsDg24
         Li90SRFaw+Zb2C2e2GgLFldJLspEO1AaNFH/9CIndM4j4APxk+0GWfm9oPfxSlX7X1eD
         fco3DSZ/BFiRl/mfU5+MvVHReDWtPk+d0Bw0mML0jwKb2y1c/Tm7BirEBafHynUwv6fV
         kr529lYl/LmQysyIjWwVM9I9nYfUj99gnCFYgYbubXMfsqBBdgppckuQQeuDHdyW1KWA
         fY+Q==
X-Gm-Message-State: AOJu0YwKPN6Wvz9MWYTnLAzzd9BcZds+urscqKFPn3zuOD8U4IMNb+L+
	vx/7IfXTnpEUlk6pTLEQ0UbKHF8AKLy9WZkZfFE/bhH+y6ykEGFYMLU4bbYczA==
X-Gm-Gg: AfdE7ckqkIict/XP2Mw5gvUBQDxLlRHJ241crvsUIh8UMUxCwije5KwnwIWjx31GhMI
	ybNVEZJFWUEj/P5oAqbMQt3bcRysAky1c6lk/zUpZx+C4YvlgHZiFkeZvROfguw0LPgF2UH6mdz
	pwKYLraLhZAY05wggI4E4e9c5KuBGc+gGIp4gJhDdsvLQz09uPBBdEJO6bdGPEovRG8YUp4m+Cn
	l1UjLtxbC1qDKmC1t6mfDnYEMaQ5POAa9A8X04wA6M6Zco/j6hHyf20yOA/lnCnbhabsPQ8BHrP
	CqXwAwtLWbSwc0gCL6NS0w9CFizjFifyMqMP/p08sDt4PTwmXD30PdwjH+i6fM19JZ1dNt5/5yR
	bsmXDTZ7t1Sbs/Aisen8wzGagEfO9OgE/Rq8yLLaLQlb+tFQRrBW7hgr+NxNirHxS6piYqKfEel
	7Jz0dSIN3f
X-Received: by 2002:a17:906:fe03:b0:bda:dd7:2e42 with SMTP id a640c23a62f3a-c1031782478mr35748866b.19.1782199056522;
        Tue, 23 Jun 2026 00:17:36 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c0c5e49b77bsm460990266b.2.2026.06.23.00.17.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2026 00:17:35 -0700 (PDT)
Date: Tue, 23 Jun 2026 10:17:31 +0300
From: Dan Carpenter <error27@gmail.com>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Subject: [bug report] ksmbd: compute lease break-in-progress flag on response
Message-ID: <ajozC-8nzNMn_jaK@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Namjae Jeon,

Commit 2b6cbd34ed55 ("ksmbd: compute lease break-in-progress flag on
response") from Jun 18, 2026 (linux-next), leads to the following
Smatch static checker warning:

	fs/smb/server/oplock.c:1446 smb_grant_oplock()
	warn: inconsistent indenting

fs/smb/server/oplock.c
    1434                 goto set_lev;
    1435         }
    1436 
    1437         if (lctx) {
    1438                 struct oplock_info *m_opinfo;
    1439 
    1440                 /* is lease already granted ? */
    1441                 m_opinfo = same_client_has_lease(ci, work->conn->ClientGUID,
    1442                                                  lctx);
    1443                 if (m_opinfo) {
    1444                         lease_put(opinfo->o_lease);
    1445                         lease_get(m_opinfo->o_lease);
--> 1446                                 opinfo->o_lease = m_opinfo->o_lease;

The commit randomly added an extra tab to these lines...

    1447                                 opinfo->level = m_opinfo->level;
    1448                                 new_lease = false;
    1449                                 opinfo_put(m_opinfo);
    1450                                 goto out;
    1451                         }
    1452         }
    1453         prev_opinfo = opinfo_get_list(ci);

This email is a free service from the Smatch-CI project [smatch.sf.net].

regards,
dan carpenter
