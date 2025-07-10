Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E658E2F3E
	for <linux-cifs@vger.kernel.org>; Thu, 10 Jul 2025 04:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752121054; cv=none; b=Izxim514C+cwx5xpY/b7PWi47/3nwcVwkROF0R31fqbDFW8WmyGXuPDgMEGh98wPqNp8ZC+bDT/RvAkakwFzzMKh1R/m4daO+uyF+wGsMxF7Huvk3ffXpalDtiAIkwMQ6ZkkwILCYCocazuDI/fl4mbKOv2mfRqRCbNUic9Rghs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752121054; c=relaxed/simple;
	bh=TakYEkzftuo37tG93NiiuM504vPbreR/sQL/dq1IE04=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=pEnjK8peXPqBNR/R9RMQHEXgSN6Nfowma1rRSK0c2ySdUl8/hKAd9sAAYE7JQ2lupJlDuiWv/YIA5KdWc+hBmqcotBx1/BUrgOfttIBc+Iulo7aPRFDERGYyg6Q93MOVZsDXguoEMVC/oe45CpQbs6DN516hxu3xgeVP+DIx8q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ih+c+Qua; arc=none smtp.client-ip=209.85.222.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ih+c+Qua"
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-7d5bf3300e0so55255485a.0
        for <linux-cifs@vger.kernel.org>; Wed, 09 Jul 2025 21:17:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752121052; x=1752725852; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=8bCtkpW+iq79PPcECpcYI0zfM6pAKFYYwYNRsdMC30Q=;
        b=ih+c+QuaYdN3O7OqkYUhijCIbyQkBWxZM7gMAToLPAWXx5kKPgRsohBX0c6t5zGvdO
         oqWg7pWGP9wOSWQFHcdyIKfYRCdGwU4HMZTD1aVfi+wyvhQjneh80N0Qrg+ZR9EkNAOi
         f9f8K68uPMjDXnfj8WVCB4AoyS/232UlUs8kN8Ry6mk5uyciNUH1pA6jLZvVPVEfBKRv
         a6q7On6OK8LWiF7eswrl3pPBQ88J0GVrANimNA1o+HuJZIIu3DNJjid0OPTMv1W4ld0j
         4ZvOaJ/Wpz4Y+po3MstsWL5mTr4lhV75jKHJKDS6Jj/M2XPJvYOFgDm0M3EMc1vTbnAt
         KVqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752121052; x=1752725852;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8bCtkpW+iq79PPcECpcYI0zfM6pAKFYYwYNRsdMC30Q=;
        b=kttmC+zjesP+akCzaZk4RakLQ5JMp3eS40bBBl5nLNyNxQa6SMceij9l1sl++16Q1V
         pVD6m58zL44AqlGwsILTkgLp7WL0CClRyGylxmu8pwPEMfGErGVkI3BPnBJi6oOEnU4C
         sLKJpQrZFQI1Mx7lC7i8ko5LwXnp41ArDfasRLOoUB/27e9EM/jO5FxDAJffwlDZ6A0v
         gJaxIslozg8D+Ur6W7+6YJ45sEybUJwgIseTaWIYcSNA+4nJCCkQLlcNow+6xmkJznKW
         J/lwGs4uEx2XbbFcFlk6/acUhfm0kUo+gUM7dJMLehHo+oS+yE67J+dnh3hZyjpLw1Md
         c+HQ==
X-Forwarded-Encrypted: i=1; AJvYcCX4eV8pH6XZPPxmkf3jSr6ovLvMka4UZgnNgq7Vt7bRCzREtLKfMfVlkSrIoGksADgVI4h18ac5CdjB@vger.kernel.org
X-Gm-Message-State: AOJu0YwNSZP4Gqugp+KH0KnE5fKTil6k8qU+VTqhUKk4mlUV06itz3xd
	lA6CY2rlOHkH+WmhhhkaSyHMFdrOuctJM0Y5R120iawpGMjd/8uzt4f3lOPraS/7IaXP9ZgmuCE
	dRsvuJVUtlHP0Zj/+57VeQHSorYb05aIMWWvYCcw=
X-Gm-Gg: ASbGncvAD+m7r/7jFHVw8febSxm8KauGryL1xMzipf5FK6lEffmIuUgruwQGcmKqK8Z
	7NnSHgvS8iXK9iKn7KsrptIhMDhxRvVtTT0adO0dOF0WE8eZwxc+6SsCu/IpNbfH6zc3tiQ6SzP
	g5xfuhAQ77wEJ8VYeAxfF8UpfqvumS09/hlIy4qAeauroSX0imhM0U1t8vY6hQqWvp58uGcgY2v
	K7pMUa2GkX1MH0=
X-Google-Smtp-Source: AGHT+IFNFzV4xwnvdI/o6DEIOt5bGXzLum1q0WMR0we2wqWqz+wzD24rk+rWBaiwfcHV76jkOe/UaQwmIZGnTzDmuKA=
X-Received: by 2002:a05:620a:1a81:b0:7d3:8dc9:f438 with SMTP id
 af79cd13be357-7dc92c84c2amr316563485a.17.1752121051663; Wed, 09 Jul 2025
 21:17:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Wed, 9 Jul 2025 23:17:20 -0500
X-Gm-Features: Ac12FXzd95UuYiaKQXt7Zf3mDVwLbHSfIvMggnvdcSLPbLWHoNEQ09TkItvxWGo
Message-ID: <CAH2r5mvKXfktSaikDTAspOTvOitpP0BDL6+GdVvptjSsKoZUNg@mail.gmail.com>
Subject: directory lease bug where newly created files are ignored till lease
 times out
To: Bharath S M <bharathsm@microsoft.com>
Cc: Henrique Carvalho <henrique.carvalho@suse.com>, 
	samba-technical <samba-technical@lists.samba.org>, CIFS <linux-cifs@vger.kernel.org>, 
	Shyam Prasad <nspmangalore@gmail.com>
Content-Type: text/plain; charset="UTF-8"

I did some additional experiments with the scenarios we were
discussing (eg.  "ls /mnt/ ; touch /mnt/newfile ; ls /mnt") and
although your fix addresses the problem it seems more performance
regressive than needed.   A smaller version of it that I tried worked
fine.   See below (removes the apparently unneededd
"close_cached_dir")

diff --git a/fs/smb/client/dir.c b/fs/smb/client/dir.c
index 1c6e5389c51f..fc5a2d7ec4f6 100644
--- a/fs/smb/client/dir.c
+++ b/fs/smb/client/dir.c
@@ -190,6 +190,7 @@ static int cifs_do_create(struct inode *inode,
struct dentry *direntry, unsigned
        int disposition;
        struct TCP_Server_Info *server = tcon->ses->server;
        struct cifs_open_parms oparms;
+       struct cached_fid *parent_cfid = NULL;
        int rdwr_for_fscache = 0;
        __le32 lease_flags = 0;

@@ -313,10 +314,10 @@ static int cifs_do_create(struct inode *inode,
struct dentry *direntry, unsigned
        if (!tcon->unix_ext && (mode & S_IWUGO) == 0)
                create_options |= CREATE_OPTION_READONLY;

+
 retry_open:
        if (tcon->cfids && direntry->d_parent && server->dialect >=
SMB30_PROT_ID) {
-               struct cached_fid *parent_cfid;
-
+               parent_cfid = NULL;
                spin_lock(&tcon->cfids->cfid_list_lock);
                list_for_each_entry(parent_cfid, &tcon->cfids->entries, entry) {
                        if (parent_cfid->dentry == direntry->d_parent) {
@@ -327,6 +328,7 @@ static int cifs_do_create(struct inode *inode,
struct dentry *direntry, unsigned
                                        memcpy(fid->parent_lease_key,
                                               parent_cfid->fid.lease_key,
                                               SMB2_LEASE_KEY_SIZE);
+                                       parent_cfid->dirents.is_valid = false;
                                }
                                break;
                        }
@@ -355,6 +357,10 @@ static int cifs_do_create(struct inode *inode,
struct dentry *direntry, unsigned
                }
                goto out;
        }
+
+       /* if (parent_cfid && !parent_cfid->dirents.is_valid)
+               close_cached_dir(parent_cfid); */
+
        if (rdwr_for_fscache == 2)
                cifs_invalidate_cache(inode, FSCACHE_INVAL_DIO_WRITE);


I also noticed that this does relate to an xfstest (that should have
caught it if we were running) generic/637 which seems to test exactly
this scenario.  I will add generic/637 to our regression test
('buildbot', and have already added it for tests to Samba since it now
has dir lease support) so we won't miss regressions like this in the
future.

Also another unrelated thing I noticed, probably server bug in Samba,
was that the scenario   "ls /mnt ; (go to server) create file1 ; (go
back to client) "ls /mnt"   was also not showing the new file (and
clearly should have) due to Samba server not sending a lease break on
local file creation - so Samba server has a directory lease bug (not
hanging an inotify on the directory to note new files being added
locally).



-- 
Thanks,

Steve
