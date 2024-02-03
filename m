Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FF8CF9DE
	for <linux-cifs@vger.kernel.org>; Sat,  3 Feb 2024 20:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706992378; cv=none; b=hWZwpT6YwPcw3T5jSQPQAbEic7JzhYhAEY8yzXXSkjoSr6P2YlSrd5gFM9OC8DlqT5us+NgbD0MJmEns8bJSfvD+2Koshd9Qbkrge1DXzP9PIKqykZMN2pCUvP6zJ+1fK/3jUQCfamN0+/T1t+7Ct8Ft7IQ1rgPGvm4R6VYGp+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706992378; c=relaxed/simple;
	bh=61sYShbFZXzE0jT40XPYlMgD34HfO1qWHNZA1tDOAnA=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=H+1SrfuPr/StIGswXaALsL8O6WLUUa4FAPCZfspwN+TzLeRoXH3l/VP4yH4Fe+xTq8SSMzaaI0BQ4cwC/nFNJneXMrTtvYG0v46XB1Yfyk3sVusQCaOKWK9pVt5d8xLz1xtaOUGI2ziI3Td+vGBE2uiKDbM8vsAn8+UMfnT0cBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VvsCOEAz; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VvsCOEAz"
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-51025cafb51so4827766e87.2
        for <linux-cifs@vger.kernel.org>; Sat, 03 Feb 2024 12:32:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706992374; x=1707597174; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=hLhgKpJMLjNhR7XXYdOsOPilfyu0cZhLBp+o5JCNLWY=;
        b=VvsCOEAz3CEfH5XeATTBoyh/E73BbUt56xH1++AZ4aLfqLAN8lps6upWm1riMNeLyI
         fAFTyrJwM5fDKb8EurV32sehH9knbc2Fjn20qf5uXeJO7u/0pVBDef00pgsDbBJFCFX1
         qeG6DHOpd4FnFdljqVqnFgd9GAZxUv8z+EjKFQ6J9HwNEpaBCbmWjpDJmA2AWPabhvKa
         9Ze7exnuhQZarbXeLVAD4J4AZi/EUj3rZ26N6pGA0UtYHIxjvvunSAjYjF3XW5OG05Oe
         KpV9DVlXwaiZSCLM05DntffSpg8tKf4OJOLzWoDFWWFQ2AHxQ1fTnAbyAdMKJzUooEAz
         Lw5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706992374; x=1707597174;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hLhgKpJMLjNhR7XXYdOsOPilfyu0cZhLBp+o5JCNLWY=;
        b=vwLsXqIDaYgVIti03v22PfdC2hXaB0tC88+ilqbTdzuCDw2WS9UP7UUOWAcSltlWpi
         3IZqZCoI6vzP2+fI+xYABuSwp4svvGm/qKjocG+ZDxc+JOWFu+vjg5NCOEqwieCfWRjl
         v1OBrqTVPHY1CaQ4VGanJCWKf6zsmtNAXw6e7BvKU4C/2Q1skpOzHuJ5pFTOVw0a7mw9
         1sdOIgtgl/I29ljEXSlfkXQ3Tv6AJjmQAaPyfonso8cWdLo3uDOL4ZucMvZ1gG5FjQPj
         6TFgiNf24WFdQJZqYXgky7GjXahMfCUn9OrcDkOaK0HXswu+GNbLbkc41xyhwIJ1tC76
         UeFQ==
X-Gm-Message-State: AOJu0Yz5tiUZLsrmkTAq+4F6MxMLVZLFB1WeGtOJpUIGsQEYHovQi3ND
	VQlhTOh+QiZD5V1zGhM5g4GH4NWvLD3Vz4pb6jHJg/E/NKGSILOXnHqnQAL4pQNOU+EBlQuwbIj
	0YXytqrvQGJhz0dmPLHrYfH7wF7E=
X-Google-Smtp-Source: AGHT+IHKB7dtAyQUhH/1ycobmqklXX5jBLBYzNQ2Zig2jmWHlJEUVOFKVEMsYTDZjYVdbGBZhCbRJ3zDCJRzZRrPkRY=
X-Received: by 2002:a05:6512:23aa:b0:511:4285:4da7 with SMTP id
 c42-20020a05651223aa00b0051142854da7mr1798726lfv.63.1706992373989; Sat, 03
 Feb 2024 12:32:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Sat, 3 Feb 2024 14:32:42 -0600
Message-ID: <CAH2r5mueWCC5aa+7t=qOhDLDYTfYDa+8ku+0GOqFfaTHWPNQUA@mail.gmail.com>
Subject: workqueue warning
To: Shyam Prasad N <nspmangalore@gmail.com>
Cc: CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

I saw the following warning about workqueues when running xfstests
with multichannel to Windows server target (at test generic/048, which
failed due to umount busy).  Any thoughts about whether WQ_UNBOUND
would help?

[ 4525.116583] run fstests generic/048 at 2024-02-03 14:17:11
[ 4525.290294] CIFS: Attempting to mount //172.30.144.1/test
[ 4525.305238] CIFS: VFS: Error connecting to socket. Aborting operation.
[ 4525.305244] CIFS: VFS: failed to open extra channel on
iface:fe80:0000:0000:0000:f196:776f:4b2c:fa3b rc=-22
[ 4525.313835] CIFS: VFS: successfully opened new channel on iface:10.20.15.198
[ 4525.364120] CIFS: Attempting to mount //172.30.144.1/scratch
[ 4525.377185] TCP: eth0: Driver has suspect GRO implementation, TCP
performance may be compromised.
[ 4526.365222] CIFS: Attempting to mount //172.30.144.1/scratch
[ 4526.376402] CIFS: VFS: shut down requested (1)
[ 4526.467346] CIFS: Attempting to mount //172.30.144.1/scratch
[ 4526.495301] CIFS: Attempting to mount //172.30.144.1/scratch
[ 4530.882149] workqueue: smb2_deferred_work_close [cifs] hogged CPU
for >10000us 8 times, consider switching to WQ_UNBOUND
[ 4542.382103] workqueue: smb2_cached_lease_break [cifs] hogged CPU
for >10000us 4 times, consider switching to WQ_UNBOUND
[ 4543.650093] workqueue: smb2_deferred_work_close [cifs] hogged CPU
for >10000us 16 times, consider switching to WQ_UNBOUND
[ 4550.478063] workqueue: smb2_cached_lease_break [cifs] hogged CPU
for >10000us 8 times, consider switching to WQ_UNBOUND
[ 4565.381997] workqueue: smb2_deferred_work_close [cifs] hogged CPU
for >10000us 32 times, consider switching to WQ_UNBOUND
[ 4569.933971] workqueue: smb2_cached_lease_break [cifs] hogged CPU
for >10000us 16 times, consider switching to WQ_UNBOUND
[ 4587.181886] workqueue: smb2_cached_lease_break [cifs] hogged CPU
for >10000us 32 times, consider switching to WQ_UNBOUND
[ 4601.121822] workqueue: smb2_deferred_work_close [cifs] hogged CPU
for >10000us 64 times, consider switching to WQ_UNBOUND

-- 
Thanks,

Steve
