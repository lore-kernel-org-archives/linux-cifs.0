Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794482213;
	b=NQ3ZNu3O5xRjO0Y5JZJ1i8ILa8D2udcfEwf5bX8mv7s2mZ8tgiim52A1t4wsrp7J44vM
	 Y37WpAXZMQltchMQbxlxXEU24v89fFUkYf+0J2rnVOUPnj1KjpGKVsAo3ju56bEiOj66G
	 PhgO19RDprxHJxW3kiYICIGcUD2yOptWIPaOnp0nobboLOHuboX4i86kiSTpzaj9FYiIo
	 jJucDA+oUjVPuHCM8qtrqP0TOQtVSaLJEK0qIR2TkagdS6J0KNnv77g84FEtlnQtZgqf3
	 QoJThz7Mi058GMGEQhGGo9Tbj2BZ85vmS6LVWH/kqLJ6m3+SxV1mYFqnUsGgEDdghkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794482213;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CWU2vsXjhQLUV7+EejFdv1HbsrszlavQIA5htXshp0Q=;
	b=ajpP5zjE1NKIISnDD5zT5VvKb4VGOwhGhGNGVNW4BOOYz3x58QxAKN3IWgsUQONy8w7k
	 3OkqCQ27wDoYhU7hcqRPeDNXA9Et02PtkLHG8/uPz9jHi3hdTh71n8/ptyWqNZ8ks3vax
	 1fG+7ifNTROXJQzKaCNEfcWNrbkRyVL8AaG7XOT0Cd/n0fi0a+sw2bGTc946JhKC1GcOY
	 N675FTqGH37MyKDTIXXLApAdYsc+zfAFIDVL9RC6x8npjt1pjOWEV66u6Q4k/mNKKrt6o
	 h69dGqO8ZLiOTvbzT9Do5mdEkjTQ0GD8gEWsUWp8WqIpLpnTj6YhfjcKi5vtlur51Cg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=b6Ax5ZCp;
	arc=none smtp.remote-ip=209.85.128.43
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01073606A33D
	for <linux-cifs@vger.kernel.org>; Thu, 12 Nov 2026 11:16:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 01073606A33D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=b6Ax5ZCp
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4b467581b98so38366345e9.0
        for <linux-cifs@vger.kernel.org>; Thu, 12 Nov 2026 03:16:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794482211; x=1795087011; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CWU2vsXjhQLUV7+EejFdv1HbsrszlavQIA5htXshp0Q=;
        b=b6Ax5ZCpAV4B8xdNDZ3RpEpa+f36xdvmSa51GnfoTRnLjn6WBeMPdDNgu1PTeAL1q1
         Eu+kZTi2XfCcqWV5kkVN8+//JqlJw6UhXV8cMk6TXLnQzbtI0A+Hu3p8Op3r2ykWKBtf
         /8V2Ii6fblkEkGNiE0ZoE06oMtsJSQQqt5XbhndJruw5eV/WaBSsqExMyNxlEV4Pghnl
         ckYv7TW4mxTBLFNnztBqXcwuP5whZr9hJ5kLh2qLI9qVpkQMH5Fi2yPS5it8oCZComXQ
         OYllba5gW105m428aZBrf5cL+1k+y1YJmzglU6wETkW695Va78i8Eu35yH5VPjGbWUrq
         ahsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794482211; x=1795087011;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=CWU2vsXjhQLUV7+EejFdv1HbsrszlavQIA5htXshp0Q=;
        b=hRXkMDr3YmyI6cha6Rb/A70RaNTSXGSVxvc+o6kEYYzvUiDodVuhwcZQu/NxIAP/fa
         f80D+LscPL8w5voz5yyFnJFKQTYv9wJicV/3QDp/HH7/1JFtn/A8yoOCI1nCpHe7z0Mi
         c2w4mKblUcCblouVzDKHVA+DHWlQg66+tzL0Dw5y9AW4xajsWELqcQtSqTe0SmsNB9EE
         lTondNf/ABbTxf2v12S2Lv/WCacVFDtzc1frNgiavIqLJll8NRlMe2v4ykSmUw1nx1vL
         twmi7NTwy1YxvnKlXYSVj4xe4rgWeJJ/0cQOXxrg/jrxk1ath7mkPrlwPNywUWxC4QkZ
         qzMQ==
X-Forwarded-Encrypted: i=1; AL+hErHFxsMyfvK7YnoLBZmB//ATj3LKbQ7AHW53L6wpg2a9dsJ01f46x2FRKNOb3hXAknbS+7udYrigxxKY@vger.kernel.org
X-Gm-Message-State: APuU4Z8lvJdLrzM3lCCKjCXFrEIiI+DHUOXpTaX/9v7h9eKCHmZ6ubf2
	u6msX1hQ3cWxOGkZ2hAdxuILGvQMjTmRUlfK0xVXRndvngjAwy9PPJ6m
X-Gm-Gg: AYBFou3QUqIDsKbW3KxdanQikbQi9krWfkiHvrv4iMUB5tinTxUdtpDPQGU+xD+y3Xy
	V/FljMsdCCQ9OBHr5HBRBS7rs6f5zHN0olpV6eHaN/K2KdjrdaeHu58Ehdwngr94RCKnLMWRbHk
	r6rVj0023YdIj0dGbMWJniGir6rLg+DBw48EQRB98EWBm6Vqk3UzDkC24ET43jgN2uLpcgEUHCG
	nAcjc0uSyTBkftX/wBqlyJj4HppPM76n60xiRImQzahB7Eo4WcxGDjs4mg3Xq89oV9MROluOdQp
	SssnSolRkC68UcuNfAP7Qczmh6SRCT88m0cvaIu+oXf3bzbmn0ZuXhCN82TQc2AM3+aT/BeVf/U
	Gdv7KTiti4NPWjZjbadmbBIZeAfli5F+ATucyg/KIiAVRxhCRxBD4Ch5J5lrQu29HrW6Aknd/fH
	x16aWHPhxD1zGqNP+45VywRILKoU61MPxDclOx+MhPgPKwhrrjKq/XxQK0V6ApwoeF93I3bGLLe
	+B3eQSK3O4Vsdd0uFuKjahSRvEFXHzbKMHVkxVIt31EGAMTbtNXLKbZp2zqeLF49oTYUFd3vZzA
	ktBjK6z2akNghdXJ/qxMpQH4TFYKaMFpDxm43ZlOjOZx3bU=
X-Received: by 2002:a05:600c:5246:b0:4a2:a9:ed5a with SMTP id 5b1f17b1804b1-4ba09381133mr96434635e9.8.1794482211259;
        Thu, 12 Nov 2026 03:16:51 -0800 (PST)
Received: from infinity ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb4e267dcdsm59120225e9.11.2026.11.12.03.16.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 03:16:49 -0800 (PST)
From: koraynilay <koray.fra@gmail.com>
To: Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Bharath SM <bharathsm@microsoft.com>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	koraynilay <koray.fra@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH 2/2] cifs: fix negative timestamps being read from smb
Date: Thu, 12 Nov 2026 12:16:37 +0100
Message-ID: <20261112111637.184045-2-koray.fra@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261112111637.184045-1-koray.fra@gmail.com>
References: <20261112111637.184045-1-koray.fra@gmail.com>
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When reading a timestamp before epoch 0, cifs converts it from NT format
to Unix format without normalizing it, leading to the nanoseconds field
to be used as a negative number, which leads to a garbled stat command
output.

This bug also violates a struct timespec64 invariant, as documented in
the set_normalized_timespec64() kernel-doc:
[...]
 * Note: The tv_nsec part is always in the range of 0 <= tv_nsec < NSEC_PER_SEC.
 * For negative values only the tv_sec field is negative !
 */

Reproducer, with /tmp as the local filesystem folder exported as [test]
in ksmbd.conf and /mnt as the smb folder mounted with mount -t cifs:

  mount -t cifs //127.0.0.1/test /mnt -o username=user,password=pass
  touch -d "1969-07-20 20:17:40.123456789" /tmp/test.txt
  stat -c "Server local (/tmp):   %y" /tmp/test.txt
  stat -c "CIFS client  (/mnt):   %y" /mnt/test.txt --cached=never
  smbclient //127.0.0.1/test -U user%pass -c "allinfo test.txt"

which prints (stat output is garbled because of negative value):

  Server local (/tmp):   1969-07-20 20:17:40.123456789 +0000
  CIFS client  (/mnt):   1969-07-20 20:17:41.()*+,--00 +0000
  altname: TESTT~K6.TXT
  [...]
  access_time:    Sun Jul 20 20:17:40 1969 UTC
  write_time:     Sun Jul 20 20:17:40 1969 UTC
  [...]

Fix this by using set_normalized_timespec64() in cifs_NTtimeToUnix().

Fixes: 2ae83bf93882 ("[CIFS] Fix setting time before epoch (negative time values)")
Cc: stable@vger.kernel.org
Assisted-by: Gemini:3.8-flash-high antigravity-cli-1.5.3
Signed-off-by: koraynilay <koray.fra@gmail.com>
---
Yet another small fix I found while implementing ptime[1].
(Still not the last one :c)

Thanks.

[1]: https://lore.kernel.org/all/20261101015551.786044-1-koray.fra@gmail.com/T/#t

 fs/smb/client/netmisc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/smb/client/netmisc.c b/fs/smb/client/netmisc.c
index cf737ede1ab3..033ca8f7e151 100644
--- a/fs/smb/client/netmisc.c
+++ b/fs/smb/client/netmisc.c
@@ -133,8 +133,7 @@ cifs_NTtimeToUnix(__le64 ntutc)
 	if (t < 0) {
 		abs_t = -t;
 		ts.tv_nsec = (time64_t)(do_div(abs_t, 10000000) * 100);
-		ts.tv_nsec = -ts.tv_nsec;
-		ts.tv_sec = -abs_t;
+		set_normalized_timespec64(&ts, -abs_t, -ts.tv_nsec);
 	} else {
 		abs_t = t;
 		ts.tv_nsec = (time64_t)do_div(abs_t, 10000000) * 100;

base-commit: f4692d0e3b5e16d32d4ec7b1e0e58d7dbe74aaf4
-- 
2.56.0

