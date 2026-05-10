Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 575DB1DE2AD
	for <linux-cifs@vger.kernel.org>; Sun, 10 May 2026 21:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778448993; cv=pass; b=tdxpA6qYevWbSAunMrQWtSza2EmZOvQaVyscYW6vrkAgc9avPSR8uAm9goggRaoVIfSvutjs7Y6+t6oNo6lVczMcYqVR0EavyDU/JP3mszilbz4rDRRtdex4xSEQjRf8Pi6VpL/V35KF+zauuQqH5bTqVDsc4IaFt5bcZVnHLOo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778448993; c=relaxed/simple;
	bh=BZeF7psiOqUodTsUlp8cxz+AO7Mkd7E8JEpoQ/t3B0o=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=PoDOA9ixQzgoRYB6CcM4STmdQBRr0j6KgSZsktiryR0Vtd6A/bjhvm4s46jBGEYvaltohgxVnijmyOCoiZz+C4ZKe5rOz1JtSyl9qc49IGLfnyQ6dEDSZ5lwhotuVTTMB2zGK+5he+Y/EiVMMSTUaLSFJlqVTB0QoSWNdtLcAZE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IbDhLUtY; arc=pass smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IbDhLUtY"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-512f09ecc67so24566061cf.3
        for <linux-cifs@vger.kernel.org>; Sun, 10 May 2026 14:36:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778448991; cv=none;
        d=google.com; s=arc-20240605;
        b=AwcRGiRvEe3hptmls5G2fL3+s+IeI8QXlgvFzBVDUgys4F+7tU1kQUzb8ztwc6O1zm
         cpw5HAUu1J7THu1UDIgvEj/aluAV/OEEh0uRTpUkDO5qtmpZFxevI+QzgpzV/D5Pzp7I
         U5Da5k9/dC1pEKWsYt8WnV7qCjbDzBfkUXI9pI5NKD2FNEVY8DU7Xf5IAmoWiYceaFdr
         m8Sdix1s0hGteU+Hv0O0Pm6/xfbb27XyZmScvy9TfkMPYIF6w6BECXRHhPwUWz7638F2
         NHGDMK6gQ1CxlS/bVCvF5i2nbyExpKZdhT+A7eNjc7EJBJp1h0dwbBwfDBLby3czjy83
         ggxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=/s2hZwCicpk0GIkEV0yT+fxR95uTmgucLT2jYDFC+nw=;
        fh=0fNr2rcvUMAhIj+RDEcmvzN2WW3UqPgzSG/SZBOl/TQ=;
        b=aRfLOr9tyF2NdWFGn+tnA6+CmOQidphDPK6FCV3bgTxxFNOl8k4BdQ7sd0MLGTMdok
         xaVR0zbtz9C9BgHcg1okJbxLvYiYRn9J652kZE5TMvQR1CiWFUJ6PvHXSWTYOVEGr926
         2fb7rH5o7LFh9wUhee43kbWmM0z/fD3cg0V+IdwKI+TxQj3wsLA7ycfImTn8vdRZuWpB
         VtL4wdYPkCakNXv1fCo/W9Rc1T5ZVPRQ0Uc7wMSb3kXEl9twfovE9cAcVc4f/FwDd3ws
         rjiDOJAKU5V2wdA4keL7PlANMekZ2en6TM2EycHJP8lbwE/+Nox9z4jbeJp0PZvOjUq8
         Oh6g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778448991; x=1779053791; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=/s2hZwCicpk0GIkEV0yT+fxR95uTmgucLT2jYDFC+nw=;
        b=IbDhLUtYGJzQKDwUWUM40wRzT9D9m+YpdgPKeLU+Nwai1sXSd064heVZWvg9bEE1ka
         2iIXaj2bmwIyHthuNEsGkLr/jmny/x3lG/JXSGW4DY8tLjvcdUnyc9FlSUT21J5SGgQ5
         xtiA/5yixBwgYPYeSWyOFyfMvf7QB7dR74uIHoYpPO/5pRVxnpoc1aeolzV9Uv8hb1OB
         lHu5oWToQxYF+oCQx/vIgxTA25fyQ64RM+Wc8wtEP1n9wIzm0P+w+ycVzYwvJJSVEcHU
         2Lgw7kMEz2+9CgvaWq/rqHulrdmAZQNKdPyiZceybAOjuJkr1VHBN+ej34FeepP8D5F1
         YrKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778448991; x=1779053791;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/s2hZwCicpk0GIkEV0yT+fxR95uTmgucLT2jYDFC+nw=;
        b=B25qFV7ZGZncXuzcbZpNStbVqqIxf9FxwvMk2VnlbCf+5HUidmqUpmWNUQdqSEnwR0
         rKONd1yRiUC5xl3T6JlYSKCfOGWf2GsJ6ONEn5lNdKHYfF4mpORb4VRI0Q1XsFkuPluu
         nBAGarNvsaDb5GjFrjriXMUwj7uBo/XMYuslFlDvrwJF8vAXM7PD1syaPpGqty83oQ99
         TAPfT78uDzObF0QWsj298twKkrBKJdtC44L2D6GQ0Glzi1VUv0e6Qua1jMhvHtznhlpR
         HUVjE72X0d/EF3ke0sMDjgctDPikBT/9z0anN/PA74RnlrHBMB3+hUNLsFYbGHA/oa6p
         C+BA==
X-Forwarded-Encrypted: i=1; AFNElJ/6fIY8AqlpU/yVVg0/QBuPyJrhU5Sa4vLQE6+L7ZQeGBL66ICJMh/eo3/c/+xKqV9q27qrenINDkwq@vger.kernel.org
X-Gm-Message-State: AOJu0YxnNB5M6Hu/VQACemRwuZBugTMqRcKkA1M6qGX09/Rz9zFeRQmV
	YAAa5Vive3j7HRl6VbuNYsSVf8hBac3cZTnNQs14kPA0bJiWn9xq9ajnX6DA/BtUxeNKkh6qJqI
	/cMqpzFxwt8pnWdY7skJJ63UBuWad9mA=
X-Gm-Gg: Acq92OHDHIqUP/RTQvY7/4g/va3CAIUfoiFzHbQ1zNUs14zP4OZ3FamVaSCi2lZGCSF
	FLHNV2/9q/iwEr2FiD8CVzlfwLUwGbiuxS9wJNJJB5Bx6Cd2OapfBp1pGTga3/lk9RWdZs2rMVL
	3QHErBsbvu6i/5BAo1XyjiWiMDLZvhECMyoFZ49qaNr7Y4Py9M56zt0ajSPhS1uBiPSsGmVB2vE
	zk0tuiQVFOHmCsmTD+7UwYk++NEtShDdX/sG5L67fvZFAz/d4RFBlPeVTaq1YMhuY9CinCgEAvw
	nrAfB4uJ1pQOpKssm9YRwbl3Jf5K8unEMBjfPKpkyo3gpeEockwrRD2RzHy6IIsm+eo/bccC0J8
	KfR28i8CF6hVIh4p5fDDRhfXCobUPHDPLsPpe9MnAmP4SRZplk4FxLZPvPHXXB/ta8uKLlVenzH
	PET3KTVvqPjzpE55UHYb3f
X-Received: by 2002:ad4:5ba9:0:b0:8b6:6d70:aaac with SMTP id
 6a1803df08f44-8bc449aff20mr321038256d6.30.1778448991106; Sun, 10 May 2026
 14:36:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Sun, 10 May 2026 16:36:19 -0500
X-Gm-Features: AVHnY4JFAhK--ziKuk9Upxr5ty_nGxzLaScuISYBuXjELMeqWw3l7aiX5143CYA
Message-ID: <CAH2r5mvP9s_KMc2G-_AsP__G0S5JCmrigOT-7U_ZNu1pLf+Q2g@mail.gmail.com>
Subject: generic/004 server bug
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Paulo Alcantara <pc@manguebit.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

I noticed generic/004 fails to ksmbd, likely server bug since it works
to Samba and Windows and Azure.   Test generic/004 was recently
enabled when O_TMPFILE support was added by Paulo.

Ideas welcome on the ksmbd problem this found.

-- 
Thanks,

Steve
