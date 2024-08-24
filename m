Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9496B179AA
	for <linux-cifs@vger.kernel.org>; Sat, 24 Aug 2024 01:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724461526; cv=none; b=b+et2oZz01oMbq9MDIyDk1ZX6qd82oEDdYPYFMSJygXaMNqhOECtQKE+M6JtYtoDkvTPsN/VAfTxOo+AKB1v8MaYpJ9dneXWKaQe+MsDBIWi4dgq6MzG47AgJ9DG8EdB3Tv9sk9fx5pQrRkG+9mhBYk53VZ3abA32pDeYKTp5/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724461526; c=relaxed/simple;
	bh=97Iph8lwt2I6yCVMgT7tF7rIsmOTVTvYekR90FN1vqc=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=XoFSETR3yd/3NaVHbH+Yfadeitr8idAbbGNFLkcRXQl/Ni5duRBgP/1GZPeTFFUR3cFlJlwy3X1Gmw6qsC0gZw7CbYWLkOtlMICXbQKzTvGnnHCpxmY+HsB4w/mPFCYq7tnJapmk6S4jfAuox5vBMFNOTgIO8m2rczIBqSXU1Co=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ncsIlw6d; arc=none smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ncsIlw6d"
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-5334fdabefbso2255980e87.1
        for <linux-cifs@vger.kernel.org>; Fri, 23 Aug 2024 18:05:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724461523; x=1725066323; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=wBBGvY+iZv47XHlSdID4RZTLRUoRXvjbqAgKNvtzcfk=;
        b=ncsIlw6dTHaLEZqyb3dH3owGkpOboRzOP6K/69HNyiN3NnP0mVLzLRtdUOKP5cd6J7
         3LNHLysr2Odzsrbtuiowsrc13z+xgKnE9lbwZb3Mq87y/JmUk7pd9rlRCLhYZWcVvcH1
         nhZ9CDkf5hZhDX8A2UKIzzx67188A+C0p7N9rJwydZimFJxOe7LL1JSJzQg3uImFSDtU
         bwKy70pqHTD20MY/WwCKcUqz56ynFzbv15iO/cEWAJpw2Km81QvOhn4s4moE0/OFju7n
         2fvL7FTE87dZnfkZFf+Edpt6bxwbOKHOFOQkXMvveRImUZUNfcRy8xNEjl0iE8boMHgT
         vbEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724461523; x=1725066323;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wBBGvY+iZv47XHlSdID4RZTLRUoRXvjbqAgKNvtzcfk=;
        b=PyWrAFyZJ2xb18tAK2XrBBo5L6esc4KxsLrTgfW+LaX/fFvL1EN8b9R2RyAG7zPXnF
         xT5l41qEEKuUbuz6bknkBBTY5+4ttfoIoVY1xj9Ysu827TvRyyzJzZ5uo991lpYRMmBo
         cS61k8966+dEcLSWANtW6tCz4iZxXd3iRGho57j2h4Ojc2ci65PdLauDMfBPxu/S0nZ1
         vDLUgeZiH4SAABmki0TsutJ+c1Qd3Lz8K11NhZqOp01CGPcEpwVOdBL5V3tDQ70kWtkl
         kDmR6vley0ZAsyQwzxbnGh2lCGm2zKLOi3Vt6twXz398xse2HfBBWX09EibiTsvFac3C
         hB/Q==
X-Forwarded-Encrypted: i=1; AJvYcCVH5CF/hMVicZRdKfP3lZMsHFDog0b0EaF4GPQMjZ3IbXg57d8sEeZlhWYE4R3VlGOFHUGgpHHbkrJa@vger.kernel.org
X-Gm-Message-State: AOJu0YyXtEaL0YWv4uC4zPc2OV8CknpAxehl6Zkvlf2nxRyOzWwd5/YB
	r6GMrwXxyPTgnIlcaW97JzlT1ThyUQVtYOk0j2xGuxfnMbfWsFRjtOk5QsXJAq+5CGq9+UhuK0i
	es3egWQ/Ll00Xk0kEC7UbVP3mZrsNCV8Z
X-Google-Smtp-Source: AGHT+IFQHOqz43zYjqnQWZBZlnPCb6afxrSVQGQAsBFInXAG9wbNqyfm3dcA2csTeQO7Ker7W6yWuEBauUq3lRkiX9E=
X-Received: by 2002:a05:6512:33cb:b0:533:456a:cb33 with SMTP id
 2adb3069b0e04-5334cab2319mr2701944e87.20.1724461522288; Fri, 23 Aug 2024
 18:05:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Fri, 23 Aug 2024 20:05:11 -0500
Message-ID: <CAH2r5muJabg=dB9EkuZD26+2mnQGRYRbpbQ96UxTk2UF4ZNQ6g@mail.gmail.com>
Subject: generic/075 and generic/112 regression
To: David Howells <dhowells@redhat.com>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

We are still getting a failure with the netfs/cifs changes in
generic/075 and generic/112

http://smb311-linux-testing.southcentralus.cloudapp.azure.com/#/builders/9/builds/119

That test included these patches from David's netfs branch:

404b22e58fa8 (HEAD -> for-next) netfs, cifs: Improve some debugging bits
e7aef949bd01 cifs: Fix FALLOC_FL_PUNCH_HOLE support
ba5ed7cb79de netfs, cifs: Fix handling of short DIO read
499aadc2c674 cifs: Fix lack of credit renegotiation on read retry
f7b3de950e43 netfs: Fix missing iterator reset on retry of short read
011be46dae8c netfs: Fix trimming of streaming-write folios in
netfs_inval_folio()
ea7079dd3372 netfs: Fix netfs_release_folio() to say no if folio dirty
2305510606af mm: Fix missing folio invalidation calls during truncation
11316e31ba23 netfs, ceph: Partially revert "netfs: Replace PG_fscache
by setting folio->private and marking dirty"

In the previous run we had narrowed the regression down to being due
to one of the following two patches:
2e4fe7d5fac8 (HEAD -> netfs-fixes, origin/netfs-fixes) netfs, cifs:
Fix handling of short DIO read
  or
18993747be65 netfs: Fix trimming of streaming-write folios in
netfs_inval_folio()



-- 
Thanks,

Steve
