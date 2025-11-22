Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 257B936D4E5
	for <linux-cifs@vger.kernel.org>; Sat, 22 Nov 2025 06:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763793295; cv=none; b=PVNdN+CCiTbxXKdSZR/0LkJZjGkqb/dyZ+r9/aYnuj4l2z1CQnUVbklkWryM5Jr4UoA81r7GybisUBl7a6Yk4fwLc02M9D1HtuXeKNVwOH+go+RloJG0IiViOA+18ZzsnEytnIxvK8IMLxkCLOhYowQIxSbuN9ADw5TP8Pt0gQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763793295; c=relaxed/simple;
	bh=02Kz8fPp6mA/IDSshot0dAal4iOKc81y31cnqPmh/oE=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=qs+U2wZcaN8F7lNXCII0OwSGOCZEb/sMTDQ8bP7hrZgJT7F36kqrWjjqB+kymeb1A4aq9LhQp9AoJJwE8UFIYchV/IWGEJEjk7uZVUqgkZEQsu2j6t2tSNoXEo2ic2Q2m1jTKSzC2x1GREfqk9NtMtjT2YjDMXLEgQqTNaP1Seg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XvncpJvL; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XvncpJvL"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4779aa4f928so24011625e9.1
        for <linux-cifs@vger.kernel.org>; Fri, 21 Nov 2025 22:34:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763793292; x=1764398092; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Cxm2J6NqSLjtvzrVaPhog5W+r8/4yF+H0d8/AKPhJOo=;
        b=XvncpJvLXpULD3akHD4Z57JwvLdQ5NIxhH7F5812F32IM99Nlv4FWcr30EV6ol0jfB
         UHSO2z8qRL9H11tec+bFFcCNi9J9xJkz9l0lKwdDXf5kcUfIoIeDsHffwMo11Lscfgpj
         rQ0NtsTBg1PJ1P2nRx1R1K5ArBIvz9lqD7/nXWpiu5pevQwEARDAAALnpfCPCrxoVSaM
         kLJNaswTywQSo7kvYKPlAC37g1SWGROBcp/I9Y9yxrrQ9Subc2/sUj3Z0TBDIEHLdKp1
         ZbCvGvBiZ/TOP7iS4KmcYcf9NTydi0h7fcb3Wa1H1wVR8J+S9iSvwNlwrXxNCZJASuH+
         pVbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763793292; x=1764398092;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Cxm2J6NqSLjtvzrVaPhog5W+r8/4yF+H0d8/AKPhJOo=;
        b=PD3xAUGvjxNhZfTww6+DG1jnyll9wV5+XTfzJ2g7FX9GMU/grFzmza4T5Z80fz62E9
         rGFANjCaG8XcGr8BOcHzI3woJCrA99dyXWwqt4iaZkdtBUP00xy+LIY2SOtzyesh/wv+
         MzvPQUsLQfPPFrpDa6XgmMFNpiav3d0DZI6wNGk7txteQw8n0TvnHqD+wxMmC9eaNEH7
         XEceARP6e0O+11pTRgVsdfHoYGe43+xh+ZooiScqd9DFeTAJoAHbqnofVdym1Urqp+/y
         xUCZvg1cQ09W+lRzD/2KH47kTRfxwbYJVfQeQpCrCDBan49CRjYv3YmKN3NDowngEP86
         f9EA==
X-Gm-Message-State: AOJu0YzDWcTUPtJ5gpmh9rs2j5a4RkaDckRrg+MFQ+ucLQ4JrMwxuTps
	eqywsN4bTsZqvXLCp96HbxZmSQx3E1UJxE4Yx9VQSh0dKc4PcZSQ07Ll8lU0vqT2qstH51bcPEV
	lEaEmUDuRJLVfj1xV7K8/ElIsz8FI54P4HKYlJbM=
X-Gm-Gg: ASbGncvrh5KlQceeNVt3HaVNKD+3CL5lj/868LxD0Fh0PNJhrEXWvrZCnuYiWHfOPak
	OLesfkkmDNG4Z9UzdnJU4zCm4xHY6n9uhLpjdEQXjMxyYuFZ16yxK13oM94vWS5UsV5ZpsNhYVm
	FjvHSdIYSspshcYy+D48mBG9ub+ge96ZLGdvq1kagWTbxRIxRNkpNOsq8eSrC3LauaVk0bGkXUL
	Y4AHOmk8BegTUuZqZLbqa+YivE2P4UAeRGHp+hXO8FlQALk9oNOJB5zK4RhTjHKfg00kHUI
X-Google-Smtp-Source: AGHT+IGpbKVihy8Gf8vekT0fXwsb0dbg7rJqeL324ZUHxV4KHSGgD4uY1ZHNyOmaZDgMjkjQ00CY63coTtq56KQVHT8=
X-Received: by 2002:a05:600c:3b09:b0:471:131f:85aa with SMTP id
 5b1f17b1804b1-477c017dfd2mr43475215e9.13.1763793292023; Fri, 21 Nov 2025
 22:34:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Alexander Yashkin <alex.aspirine@gmail.com>
Date: Sat, 22 Nov 2025 09:34:39 +0300
X-Gm-Features: AWmQ_bnkQnrw5fFaJ0YngmJ66fkwM6Pj1i8Ao909iZFZ0KocBFuHK6EcbrpNtH0
Message-ID: <CADBtHDBL3Z7KdkFbCYyOfjdjCBfDsnc_i1sGHyLewpqk7hPhMg@mail.gmail.com>
Subject: Inquiry on DFS Connection Aggregation and Future Plans
To: linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello Linux CIFS developers and community,

I am writing to seek your expert advice regarding the configuration of
DFS connections and to understand the project's direction concerning
connection aggregation.

SETUP DESCRIPTION

We have a Windows Server 2022 configured with a DFS Namespace. The
setup is as follows:

DFS Namespace: \\SERVER-FR\Data
    =E2=94=82
    =E2=94=9C=E2=94=80=E2=94=80 DFS Link: Shared01
    =E2=94=82       =E2=94=82
    =E2=94=82       =E2=94=9C=E2=94=80=E2=94=80 Target 1: \\SERVER-FR\Share=
d01
    =E2=94=82       =E2=94=94=E2=94=80=E2=94=80 Target 2: \\SERVER-UK\Share=
d01
    =E2=94=82
    =E2=94=94=E2=94=80=E2=94=80 DFS Link: Shared02
            =E2=94=82
            =E2=94=9C=E2=94=80=E2=94=80 Target 1: \\SERVER-FR\Shared02
            =E2=94=94=E2=94=80=E2=94=80 Target 2: \\SERVER-UK\Shared02

Our Linux client, located in the same geographical zone as SERVER-FR,
mounts the DFS root \\SERVER-FR\Data. This server (SERVER-FR) acts as
both the DFS namespace server and hosts the SMB shares for the
targets.

ISSUE: Lack of Connection Aggregation

We are observing a significant proliferation of TCP/SMB connections to
the single server (SERVER-FR), which we believe is suboptimal:
- Mounting the DFS namespace creates 2 connections.
- Accessing Shared01 creates 3 additional connections.
- Accessing Shared02 creates another 3 connections.

This results in a total of 8 connections to a single server for this
minimal setup. In our real-world production environment, with dozens
of DFS targets and thousands of clients, this behavior leads to an
overwhelming number of connections, exhausting system resources on the
SMB server.

QUESTIONS

We would be grateful if you could provide insight on the following:
- Is there a current method or configuration parameter (e.g., in
mount.cifs or via sysfs) to encourage connection aggregation?
Specifically, is it possible to reuse existing SMB connections to the
same server for accessing different DFS targets, rather than
establishing new ones for each?
- Are there any active plans or ongoing development efforts to
implement more efficient connection aggregation for single-server DFS
scenarios, similar to the behavior found in other operating systems?

Thank you for your time and for your continued work on the CIFS module.

Best Regards,
Alexander Yashkin
