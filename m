Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B9FD54FB1
	for <linux-cifs@vger.kernel.org>; Tue, 27 Feb 2024 15:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709047390; cv=none; b=U5077CwlIBpceoaRWLF9eLj0a0H0zsUoR1nDPCuU9n7SI97RLZHRyP54FbQa4PlT65MmDJ0Ew3wuBbobGSV2zPc6UuTD99VUuFb9/MAOQC7yETcpJRSGAtAMP3g3vgH2+/0nZLt6pWJDWICBEYm6bUDr7PwyVqfJIhemcyRLCog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709047390; c=relaxed/simple;
	bh=pNSUe1j6JzEbhfRhN4fC7tjZaJNzWR148k+4gf91dMo=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=XeFSKGD8F7XdNTfRZL1hVNK/4dhWujdGe/NSq9sSyGzwWlkyGXgwoGPDBv5Pzawjd435uK/Tz/8HIaKufjnnmFqt7QRWoc2uTd5CZnicLpvk+ZXukHuALwHomHRjwvfyMVu/UxGkB3hHvObOhkQvYKuIN6jvBu5Xgcx6iOdS5P0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=atEWE61z; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="atEWE61z"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-412b15c97d4so515705e9.2
        for <linux-cifs@vger.kernel.org>; Tue, 27 Feb 2024 07:23:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1709047388; x=1709652188; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZLu9xoaZZ/zvZx9RbS72f5mmr59ofCeLSP4gb9+idZM=;
        b=atEWE61zWmTrA1yNoHVR4jRjL9j9WlngqDt8n+GWBJbKBiubHj7JTptiB5YYPA+KsN
         4DBT9Am3UHYyBzfyw8X33GZLz2B1TWVVnO9rE1GrkL9hdYJYBZocXVAWiIds9Hfr2rQU
         U1Yfi+ac14Nu5ytUSPinq78bp8r3Fgbe0JAG8mnYJiZTOZmGu7KywXmCQgpd8bsjwJKK
         WQpdsNnQOD0noRLsJ3TUi8le4TuKIB6A7nNl2QUmKntFz0nMdLlUr64UaNpIvLkPDOX3
         5qVdB+QWXZDHBREJ3UDfpW7ZmAZV9GDoVeHxV46uo/j2IkFa79Y7Tb/VGlrngwck5P4a
         Doqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709047388; x=1709652188;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZLu9xoaZZ/zvZx9RbS72f5mmr59ofCeLSP4gb9+idZM=;
        b=fJk/pO12CuMC4n3ohPGViJimOjMl5/ZhwItR/+IV6X45xqMv9kKqy+ntua+OCU9wOY
         7Vqwk4U1BFhLr+YKBaiqHTK/schOqabv/Xke2aCIern++c2HaaXzofWtp4yTdsHNeTl7
         sBuhn5xCfGAeXeKYoaGcK53Plj4Uyq1OdXWBfMB2a06AEwjDfynCjM8loBzGIVhfvSbR
         DbrTjQFkk+YP7ijkTEMhZddotltS29i5de0tCdMBhpeVqQOWOdTlAAVnhYn3yEWj8WpG
         gQrP4+EnHo1nSlW5H7II1PbxDSfL+7rLhMrNuDl/hHmr1DYM9vaajAlCmZ43tjvJtVJ9
         d+TQ==
X-Gm-Message-State: AOJu0YyuGslvmdNu+PMCZUgkEXqOut77L1UgDTQpWKDH+SXNnDZHsNct
	U0dtKgTNwS0FH1YSFyFBNYN26ZbZ+4cI4gJ0vZ8CiSvkl+mGA93F+j3pspRHK6E=
X-Google-Smtp-Source: AGHT+IF2ZIkotu8w/SK0EEif/ASzSbkjmW0uKX2H8vcXzyHK/8OXDMaPGqGoWsD+gy1KTty1vSBIiw==
X-Received: by 2002:a05:600c:1f81:b0:412:b4c:58da with SMTP id je1-20020a05600c1f8100b004120b4c58damr7864894wmb.9.1709047387815;
        Tue, 27 Feb 2024 07:23:07 -0800 (PST)
Received: from localhost ([102.222.70.76])
        by smtp.gmail.com with ESMTPSA id y9-20020a7bcd89000000b00412706c3ddasm15010407wmj.18.2024.02.27.07.23.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Feb 2024 07:23:07 -0800 (PST)
Date: Tue, 27 Feb 2024 18:23:03 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: sprasad@microsoft.com
Cc: linux-cifs@vger.kernel.org
Subject: [bug report] cifs: missed ref-counting smb session in find
Message-ID: <4bd0de41-528f-4506-9c12-d635ee478f64@moroto.mountain>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Shyam Prasad N,

The patch e695a9ad0305: "cifs: missed ref-counting smb session in
find" from May 23, 2021 (linux-next), leads to the following Smatch
static checker warning:

	fs/smb/client/connect.c:1636 cifs_put_tcp_session()
	warn: sleeping in atomic context

What happened here is that we recently shuffled some code around so
now Smatch is aware that cancel_delayed_work_sync() is a might sleep
function.

fs/smb/client/smb2transport.c
   204  smb2_find_smb_tcon(struct TCP_Server_Info *server, __u64 ses_id, __u32  tid)
   205  {
   206          struct cifs_ses *ses;
   207          struct cifs_tcon *tcon;
   208  
   209          spin_lock(&cifs_tcp_ses_lock);
   210          ses = smb2_find_smb_ses_unlocked(server, ses_id);
   211          if (!ses) {
   212                  spin_unlock(&cifs_tcp_ses_lock);
   213                  return NULL;
   214          }
   215          tcon = smb2_find_smb_sess_tcon_unlocked(ses, tid);
   216          if (!tcon) {
   217                  cifs_put_smb_ses(ses);
   218                  spin_unlock(&cifs_tcp_ses_lock);

Smatch thinks calling cifs_put_smb_ses() might be a problem.  This is
a cross function thing involving reference counting and I haven't worked
through where we're holding references so it might be a false positive...
But I see below we drop the lock before calling cifs_put_smb_ses() so
maybe it's okay here too?

   219                  return NULL;
   220          }
   221          spin_unlock(&cifs_tcp_ses_lock);
   222          /* tcon already has a ref to ses, so we don't need ses anymore */
   223          cifs_put_smb_ses(ses);
   224  
   225          return tcon;
   226  }

The call tree Smatch warns about is:

smb2_find_smb_tcon() <- disables preempt
-> cifs_put_smb_ses()
   -> __cifs_put_smb_ses()
      -> cifs_put_tcp_session()

fs/smb/client/connect.c
    1617 void
    1618 cifs_put_tcp_session(struct TCP_Server_Info *server, int from_reconnect)
    1619 {
    1620         struct task_struct *task;
    1621 
    1622         spin_lock(&cifs_tcp_ses_lock);
    1623         if (--server->srv_count > 0) {
    1624                 spin_unlock(&cifs_tcp_ses_lock);
    1625                 return;
    1626         }
    1627 
    1628         /* srv_count can never go negative */
    1629         WARN_ON(server->srv_count < 0);
    1630 
    1631         put_net(cifs_net_ns(server));
    1632 
    1633         list_del_init(&server->tcp_ses_list);
    1634         spin_unlock(&cifs_tcp_ses_lock);
    1635 
--> 1636         cancel_delayed_work_sync(&server->echo);
                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Sleeps.

    1637 
    1638         if (from_reconnect)
    1639                 /*

regards,
dan carpenter
