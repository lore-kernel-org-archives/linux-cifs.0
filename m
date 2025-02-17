Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E79722F3BA
	for <linux-cifs@vger.kernel.org>; Mon, 17 Feb 2025 18:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739816872; cv=none; b=oOvfTNW7QXws7mQzNNr1fSBjfwSsNYsw5L9MeUHYEvgQU8YK4W9CyT6t2w8wW1NlE+LoODggC0NfWiB4UfcU6jEB364HDN38lgE9jC0ANpCxUUuTVhxZt6OWUbIjHIRmvLnyUfOPSjAH+XAURBMXHNLnYyv0tSFv7wVk5ANNcnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739816872; c=relaxed/simple;
	bh=6hXexHsvI1hSf8ugWOfhbpHJhMk62owADfAFWfzq+vE=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=C9ljjTCxVitFO292SVcrGLVWpEcAAZUL4+ToxruR/VutCkugDsk5/InfnjYXnCGd/wrxH4YoZu+Wcm9JC/B74dhWch6oGnfsB7i8Cg6l9u5ODVgdrbAVseE53Acq18gMGMpl9CDs/eaL/oa/VTb9bSVaftIPxxMa2nr2Ss+oPdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PNFBkT8I; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PNFBkT8I"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5452c2805bcso3426174e87.2
        for <linux-cifs@vger.kernel.org>; Mon, 17 Feb 2025 10:27:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739816868; x=1740421668; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=4eCFEt55r2cLgcegbBBNbV9AwK89qEfHsm5IaXprc0w=;
        b=PNFBkT8IWcpalK8msUH8ds03KMe1L/1GNDcjCJH7pSo0y+wKDlB6vUI4pQeSC62Xk+
         +08bq0AOvKsuMaIAsLw4XW7yfemFIYW+PoA5uRf9csJo+jN3UaOCBfb8Hr/Te6uiXSnq
         us7r5/L26sGXWdRUgMGK2zirNLLOVhYJI5A+nNPq1wCDUm03ry+HtaIZcIywqsrnw1lb
         RfOo5JZLHJcXT+ML9uPqqH+7+yyQULxQ4ekDsIx8IuhxREnm5GWnX2v+y2j3+esJvd+8
         lTbIxdyHwffI9Y4wQF6iyEZiyYBTQE6+T50OXvD6a4b+X6/tQwioq93CLbGqwCPyLfCN
         duHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739816868; x=1740421668;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4eCFEt55r2cLgcegbBBNbV9AwK89qEfHsm5IaXprc0w=;
        b=sMc+ICezz+MsRbdYsu6qOyW+27SHuivT/GWfLKHCRhNaF7+y1lyv62JImBZ6W1HSzB
         YNzdTkc4AYhJjATQyksS+8WNxBVcgVIbEGs56wiOni0Iyq4HjCm/Nu5o3J4wsHkan3px
         o6sx5HmESzQTqEX5JCiwRDhVL/7gsn1kW+vKm0vEbboUIgc7FKztj5dwCS1BzUgrjkJS
         VScpdPQGJV7WlLU6LBT7FV64tW2HSTtGfaydh7pH9GD1xb7VXSg8aNDbDWkI+06g9ccB
         71xsrO7b6Km4t6owgzGZGdJPFYEZ/xA6o8AgV3iN/YMcgmJylw1Wqaj6HNRC72FLErWB
         mosQ==
X-Forwarded-Encrypted: i=1; AJvYcCV2UMX/orev2mgzjQ6MNqtJ2yzuhegIUjRXIOOSx4JPRgFK6YG5W8vOWeAyqvftC+oMQ5YpgNnmtTpr@vger.kernel.org
X-Gm-Message-State: AOJu0YyLz2JT2LjP0xdD1oLAvnDs4vGeF9OH8UVh6/BPkJjp3cmNH36x
	MX+yM3gbUI7PWJ0Bwcma5F7xWFCOpXnsc+hD0o/YNkZETF5WggVKERTdl8VFZg+vExZWOH7rxHH
	G/gVjGpbaScouTHZvkwqrlGOcSBuNXWxK
X-Gm-Gg: ASbGnctpA3gNACCWh8IUVxkVHw2gQ2JXIoDShesY2LFhdsH6BJmmV2p7yUyxBc7zvOJ
	yukMNUm5z9DNSJTMrAeA+MQ/mVK02dVzH6UfyIMZf7na2gQa9wDKCS5mQzVoMu7BtjU7yem9QZj
	qxlGqBxNidNkoZM2q/T3bk8ozujUKwf5w=
X-Google-Smtp-Source: AGHT+IEMDbnpR3L0UlitdqBQOp2Ec9gVq+4+XsskZ2aGOAjQIVcP5eIaZBs/1/teiIAqW/mKE+OmcCqglrR/vfeQxAQ=
X-Received: by 2002:a05:6512:a91:b0:545:617:6f07 with SMTP id
 2adb3069b0e04-5452fe2e0dbmr3099255e87.6.1739816868306; Mon, 17 Feb 2025
 10:27:48 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Mon, 17 Feb 2025 12:27:37 -0600
X-Gm-Features: AWEUYZkdrBDosFb0K9VRUcE8XhwuU9idq65t6rv3FphOMriqDCXgLrVXPkW9IYo
Message-ID: <CAH2r5mtxd=2Qz-ABKbGJ3FeghR6jBb+P5ZsMo7E=V6UXwpXokQ@mail.gmail.com>
Subject: If source address specified on mount, it should force destination
 address to be same type (IPv4 vs IPv6)
To: Paulo Alcantara <pc@manguebit.com>, David Howells <dhowells@redhat.com>, Tom Talpey <tom@talpey.com>, 
	CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Noticed this old bug today when cleaning up emails.

When the user specifies a srcaddr on mount, the DNS resolution of the
host name should only look for the same type of address (ie IPv4 if
srcaddr is IPv4, IPv6 if IPv6) right?

Any thoughts on how this was handled in other protocols?

https://bugzilla.kernel.org/show_bug.cgi?id=218523

-- 
Thanks,

Steve
