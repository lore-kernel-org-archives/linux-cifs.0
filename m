Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.98
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794927458;
	b=VLbt4LN4mXiAPb4rfis6GdltBGtJdUAHjlYFh8ZhSfv2iMnGk4IxeuOLuuY28G0Q53BH
	 h8dGIDceslMvIeyp6i+47p065YER4jE3y4J6U1ZBM/kODPmXDHBIaOS3oK+J4b3seeMQB
	 srQpLEgBtBhZLgCi0q0Yglzapzzn+UAlGc8mZTYWma3+617EnU19HDpOAXqPqf1IZIVCv
	 BtYdXxnf27jP7HBJEApEFlD6MO2yBgs5CS0njote6JTYsKMyfewaUzWe2Q8M6eGNd3p3Y
	 EC9qSpuTp/7XAsrK8XCLd2BsBS9SKAsdzzBe029cWOVOA8Hg+l3EdSkfscBUoEm0zuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794927458;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:X-Relaying-Domain:
	 X-CFilter-Loop:Received:DKIM-Signature:X-Forwarded-Encrypted:
	 X-Received:X-Received:MIME-Version:References:In-Reply-To:From:Date:
	 X-Gm-Features:Message-ID:Subject:To:Cc:Content-Type:
	 Content-Transfer-Encoding:X-DetectorID-Processed;
	bh=VaHYdskxBgJ5f/Er/TW8oHSSBf5pSt0lOXwfBFfdPtk=;
	b=ZG6ZLiyCAUGAMIy19WvHf5wtoQKm9li21SY8MM2ujEuUJ9MbN+Xx0rucKl/uBiA1Kg/2
	 Ccnqp3Xs8+mHPJQ4jfsN8oQ6SFMxUIG/1rVUjoDLeKQDekkFK3rZ7JMrbk93BDw0AesGJ
	 5tOw4AOpKE2OpvBS39AeHrUZO98nfUyDWW6Yz+ShpkzaKURNFgqDBR3aIAH4+JeFQYVS7
	 WjPrCyTTYtCi/cqEh1H4jJzTWxe+sFBDHN+nGPL53uabA6iOIqZIOLnzHNvT9QCdy6syB
	 b9V/B5fqMtg1m/YriDfs9gAv+TDcrUebPXMMYWShCUDo4oZEOAdr7GE3/3ZQdzl/mSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=NGAkj3mg;
	arc=none smtp.remote-ip=209.85.216.98
Received: from mail-pj1-f98.google.com (mail-pj1-f98.google.com [209.85.216.98])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E657606A884
	for <linux-cifs@vger.kernel.org>; Tue, 17 Nov 2026 14:57:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9E657606A884
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=NGAkj3mg
Received: by mail-pj1-f98.google.com with SMTP id 98e67ed59e1d1-3ace1f3897cso2751021a91.0
        for <linux-cifs@vger.kernel.org>; Tue, 17 Nov 2026 06:57:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794927457; x=1795532257;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:dkim-signature
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=VaHYdskxBgJ5f/Er/TW8oHSSBf5pSt0lOXwfBFfdPtk=;
        b=y9D7wryu6GAnm/CCbV35B6ZvjlOnl+4jka44zY8ugsVukYB1ghfLBorO+lXonjzw+J
         ELG4SLcU0XNqehsD50SxBe70pJQf/wxPATVBDEXYqe5AGJSXkk/Ly89NTsOUxt1rSD5h
         Mw72yoEgggT0oDse2aoV1BsbdcdLaZYzehzej+2rvrdRpaWZrvSJzHkTYlHTyjLhpcxZ
         KG7+XAN9D074Sv6A4/9VTORDJ/DfkQaVaK3HShdv+zQaXLhiqnh4cK0i9fK5K9E2Aso7
         Z1p62Do94Ei7qbSh36WSnyQIwH+euU+UWSENdNf8r8vaf4mJ5dUptZ3EwQF5euioEp1c
         x4wA==
X-Forwarded-Encrypted: i=1; AL+hErHLr4bfwsVwCO88k5Q6FOi3jMhvVrmu361+KLQgtMFRXkXjwqP0OL1McbCcjej31u/gZnJK5TnGNA+n@vger.kernel.org
X-Gm-Message-State: APuU4Z9KbOiT/tfjbPxH/9VNi6/Y32hidNMopEpDozUym53rEXrS/4Vv
	KBvzdyjjJHPxSHMvi9Qw9fpaz8dbkXpDshNfaQVrAGsLCB/JImm08Og+f1sBi9CKfa7HN/r5XLp
	E47H/+ruySj5uLDwSBkHzzaEs6KmhoA1oEjM+7HShlJRKxAb381HCsHk69cTbc0LMiNz+mtOg22
	D/5cUY0nkAAVx39I8ZC9Vt7/iO4w0hVW8puaz9nCut8i4JFq5rhT5/28GknTHo9D5+Qon4EETRP
	HjpxElfxU9628SIw6o=
X-Gm-Gg: AZFdTZex2LpJu89FXuG5G/xbu4elL1x0w7DLZEsWUvCeaRAbNnMGwXiblmjoYqlnLQG
	06EnbzqRcvX3h9vg+IbzhUYxPLPaQCbVOa4zw3ZlrXQd9l3Fa5/fHj+umRtmqfwJFnksN/r00X7
	yTJEknZE1YyPCAYBFL391q5vQ0KMwfiWKlnPFIdFgunNu6xCwS+wTJY1zBmoblEDlxihd737ATY
	ok9cTMH1MwrQ6qSQV4Bq+Nc16RiIvrvYef4FGy80Ip7LNRCDj7yHugYK9GY6YG9qIKSiyTKuGan
	jpSOR+fDY3unMcPVcCpbokld48CLuFTU5nOTcfTIUJqd1GpUBucowFiOPZ68maTc/QhZdAiKySJ
	C22ZeM027PMGDMEUCVCqfm9aBZbzG8r8fc1Mkb5PzvgT6KMEgPy0whWc1LmTifboZTCKSI6sE5N
	uHpWb2JPOn7KlQh5/DlkHlGEs11INg/fI0KpWQi/7U
X-Received: by 2002:a17:90b:394d:b0:3ad:47ce:3876 with SMTP id 98e67ed59e1d1-3b1b0ca9dfemr13153456a91.61.1794927456860;
        Tue, 17 Nov 2026 06:57:36 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-123.dlp.protect.broadcom.com. [144.49.247.123])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b3abece214sm2086386a91.3.2026.11.17.06.57.35
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 17 Nov 2026 06:57:36 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4a35db2d6b3so33683285e9.3
        for <linux-cifs@vger.kernel.org>; Tue, 17 Nov 2026 06:57:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1794927453; x=1795532253; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=VaHYdskxBgJ5f/Er/TW8oHSSBf5pSt0lOXwfBFfdPtk=;
        b=NGAkj3mgM0YCn4r+4HQ9fmXpMrLPf1Q0JvEhb50p763RLeEKqEpXkdSShpJhGrjXRD
         RX+iN8dE+BY+JktS6CPBjs2oIVYNCsrV2d1ZBJA1esoIpSWjouRiTRFNIA+aN1sXG0ny
         q0Bgx13TQEcnPJauLQ7zl3uaHNEGpiAZY9C/A=
X-Forwarded-Encrypted: i=1; AL+hErF+JwiTDBb3gYJouuE2xA5JX3+VDqwKtPbR9/6n0laDp8A6Ec8k1KvIb4sDHzlp/oVwlN3cUZEK+BDW@vger.kernel.org
X-Received: by 2002:a05:600c:4f4e:b0:4bb:6f45:2a77 with SMTP id 5b1f17b1804b1-4bb6f452d39mr188021405e9.11.1794927453517;
        Tue, 17 Nov 2026 06:57:33 -0800 (PST)
X-Received: by 2002:a05:600c:4f4e:b0:4bb:6f45:2a77 with SMTP id
 5b1f17b1804b1-4bb6f452d39mr188020445e9.11.1794927452733; Tue, 17 Nov 2026
 06:57:32 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261116074849.475815-1-stefan.chulski@broadcom.com>
 <CAKYAXd9KT=1vLYsnRKxmiM6pLJQNACXuodD8wNQzb8S5apiuRQ@mail.gmail.com>
 <CA+Fu+LPL7xqpV_vjjjehedOFtuuBqgZHZTSqJ+FgweUpYo2uBw@mail.gmail.com>
 <CAKYAXd--x9UajLQwzRUwxRZ7PFW5T02xyHdSAnThAo326p_kxw@mail.gmail.com>
 <CA+Fu+LPnXMd9rMtywkZL77XzLq8n+8AiBW2T8Cau10YnVbofiQ@mail.gmail.com>
 <CAKYAXd-xM=gmpjz7g0+n+ZBA4Vb0Sz2i7B89Cs7XdHUY7U6WdA@mail.gmail.com> <1840b905-479a-46e3-97a9-b2f40cd50c29@kylinos.cn>
In-Reply-To: <1840b905-479a-46e3-97a9-b2f40cd50c29@kylinos.cn>
From: Stefan Chulski <stefan.chulski@broadcom.com>
Date: Tue, 17 Nov 2026 16:57:19 +0200
X-Gm-Features: Aa3M54q6UrvDJCXyy-Tq8up-xKFoPuFafstRfqFIuifIOUygyu9m1cZGcxONfis
Message-ID: <CA+Fu+LNry=dgUdEpULq6vZhnLRdVX39syn4E0Qafia36dHTn8w@mail.gmail.com>
Subject: Re: [PATCH RFC v1] ksmbd: add use_unbound_wq module parameter for the
 ksmbd-io workqueue
To: Huiwen He <hehuiwen@kylinos.cn>
Cc: Namjae Jeon <linkinjeon@kernel.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Tom Talpey <tom@talpey.com>, ChenXiaoSong <chenxiaosong@chenxiaosong.com>, 
	linux-cifs@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Ilya Lifshits <ilya.lifshits@broadcom.com>, 
	Gil Benamar <gil.benamar@broadcom.com>, Florian Fainelli <florian.fainelli@broadcom.com>, 
	bcm-kernel-feedback-list@broadcom.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

On Tue, Nov 17, 2026 at 4:40=E2=80=AFPM Huiwen He <hehuiwen@kylinos.cn> wro=
te:
>
> Hi Namjae, Stefan,
>
> Simply routing WRITE requests to an unbound workqueue is not sufficient,
> as I've observed performance regressions across a number of workloads.
> I've since developed a more complete approach and will post it soon.
>
> Thanks,
> Huiwen

Sounds good, please cc me on the new patchset when you post it.
I originally tried to keep my changes as simple as possible, but I
look forward to seeing your approach.

Regards,
Stefan
