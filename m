Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C382638F249
	for <linux-cifs@vger.kernel.org>; Sat,  7 Mar 2026 18:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772909795; cv=pass; b=TW3KiN/UsyMxEgy4cgTQyVGvGGCExAjZjhXJtfZrsXjjJM4PwXgfMTy3G8dEp+SOOSfkbaPhNdSowOirpu3U2kAAlVfgcKnFP52If19FSh6rhrEuJKU3CwTlEi92wvz+gnCj02JJxMCobsxPhdgN4o2p3kX7fjkJX+1Eq9XKjq0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772909795; c=relaxed/simple;
	bh=ipPnoEwRKGay/Kqh3e72TxDAS0WvWm5QHtGzwkgIhmk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CKfRkZXV6oS/+Uy8RjTrxUpHNCJZGe43UU6yOBVRZWuZhWl8yzi4IjoCqeEnQqK7Rjrcxwt1rR/R6WjwFp3GIgMOarOyvzlyz+KF0vxI9CpD0AT+pveqgshJxduD6jobE0Lcp8ws+T91GJKoI650NoP9T124pR1Zm9K2Lx4S0qk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net; spf=pass smtp.mailfrom=amacapital.net; dkim=pass (2048-bit key) header.d=amacapital-net.20230601.gappssmtp.com header.i=@amacapital-net.20230601.gappssmtp.com header.b=UERqbxJK; arc=pass smtp.client-ip=209.85.208.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amacapital.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20230601.gappssmtp.com header.i=@amacapital-net.20230601.gappssmtp.com header.b="UERqbxJK"
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-38a42a0d7f7so10974861fa.1
        for <linux-cifs@vger.kernel.org>; Sat, 07 Mar 2026 10:56:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772909792; cv=none;
        d=google.com; s=arc-20240605;
        b=h1tysE+B+1HP/JLmwc9gb6Zk+iHskXliPM54p+v7rcrTL4OTw5X8vIMrWdG7XkcaaO
         0W8LWQ9xVpVTVTVJspNwZYtSk1TzhcYGnd/rRoC8HKU9pXIPg3wSwEyDDRLjENxCU3e2
         A3Ig2NBw01jTPO31eyW+JiTTMNZC7Z/wIbUgzX72DZhPYPX8BTUULNBE+4A6QJNTH6sd
         7qkBTYB3TzDmPrGznsH7FQ61aSgZuxNl9yDZsHWI/bufiP/B54cZaj/DfDKdYZ29msZF
         BIhUC4oOTqmdbVexfR+q9xikN32nJB+JJTky4WaX8r67yue4Gt8XVQrWWBL/Bv66a2IP
         BdMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=pxUV6l0cXcVJnfGWc1SwZOsz+kJgjCkHV5Xd2O+xjBY=;
        fh=n9yGmMUvXE2c9rlP40k+W1Iq32Pww8AlG0wFz+6OBpo=;
        b=gINbQ5WZnZ8usTEoWnwNeNMCIzpOizmpISt5nKGxb8UGuZGfitXP/0y/fovtZJoivP
         FapTaV6IKtyRsNyxb9z6SLusuUvgLXAf9y5YYKlFwG64LLM0DIiGH2R97ov4QhTSU+LB
         qPoa9cBnsTpi6Wf1nyDZQnYTGe0Z+lMs4wLZn1G/JJ70FBDLjoUUnY2EU2Ey8BMgN1sw
         idr0KYek6lpgVyneSa+GIuL/7DVyDg630u8tUzWIJvvtrHME022oIcIB7/HoE6/q7CTq
         mOiwv+lkXXC+D9PVWA+Ef30vqQ7HXPe6401wddWgOUNmIdL1l5BbrxGqVliNMpbYPWKn
         7gTw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20230601.gappssmtp.com; s=20230601; t=1772909792; x=1773514592; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pxUV6l0cXcVJnfGWc1SwZOsz+kJgjCkHV5Xd2O+xjBY=;
        b=UERqbxJKZngkPO2K4yr5YwAFzKHDjj8r0w4oJuzjCO0kMIqLOi33dFigOAK5fZJwBg
         t3vBGotLKf2C2GyPcVqTqi/0bMqWfMRpqQ5rii8Lnt1DIjrG4hklubdBbb0zBjvmrxfm
         0ACUWOD8gJuwgtD1IRPU5MEQjhc5r6adr2y3vMIGiLtTdq4ZL/+TuRATJssUP64XLQ8k
         697wEJo9Gi1YFv8vDxzYYf+i++1UCLQBSHd5HunMVb0RrP2RWyiZRuwnSv/rA/6wMP/v
         6PdybPK88LnePRQ5doBRC2ZH8V1L7CaJDdTOdndxaW4gM9uvjOm57BKxPOmZpQyF5BOo
         dHkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772909792; x=1773514592;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pxUV6l0cXcVJnfGWc1SwZOsz+kJgjCkHV5Xd2O+xjBY=;
        b=lzQnRfig5e/Z/DWDexF9DPQtccieNE/iK654nWhnaZ9zTYeeM328bNQ7FD6V1+CUM+
         XhNM2srlWtDY0BZJPJS1CwZZkhb0cFxhOlY/iyFKLkB6GzxW+TmnXOM9PcESfoMiBoX4
         trgLBUeqf/uItW/Xt1hi4bFujcxXdu4oaOmiL0s6ukZ3HUEPFEq0l198R/3xRfv5ymUV
         GZzjVcvL0zSJ+qpyXDkVUGMPmBInrrNHY5urSD0VfEy9ySB1fniKYyeUpDx1BYGWKIKW
         jdl1FA8YASy6hS43JT40yRbSSwU2iX6S/SPV8U6XXyAv7XUOP8Xa3JevSg+1Vayr4Wug
         X9zg==
X-Forwarded-Encrypted: i=1; AJvYcCVSWosbWQLnXdKlBHfkqCnB5zdhaQTbU1kfSizbo5wqtMV3X7QtYdCOOo5QXGuJdSuV7IlY2oWNoIVY@vger.kernel.org
X-Gm-Message-State: AOJu0Yz5Bu8fPOSFHwyRiW16dNE2ZzyxzhnX7kTnbBjkzJXHdbwC+mFR
	I8GhQS/2xL7Jm/xp3hfE9oZNYZywFHg4DFLOjq8hp+4Mc2duU8ofpUCfJ5grnNilI83sQmSoQMt
	tmUahhejsIqQTfaD9sb6u4VUaO3XabJ0b4MsEktMl
X-Gm-Gg: ATEYQzyc2z6f4hZVpLrTEsEyKhe1nAUhe30VnTb6tsdvcg/FVivJIaEvMxn1gyiQ7E/
	kyFWcA+Zs3iDpz87z7VXi7U917Ebt5cMBkUCa5XCpeYMA7gPW25Q4ZBS/UyFN+1JApMowwUbL6C
	wAbYbifqe6/W31AohrodcT4ayM+8yStkj7MiC51Xi/jG50Cio0FdhO3yHpcOv1StAzkSzP5Dx63
	ZT8ZUKCn97brp3ihhl72AFnYOMfa/VsiWrBOp1kl/hFCjIf4NaJjNR2+MpRtSi7TYRIWGgHJXcj
	2gbAl0Be
X-Received: by 2002:ac2:5694:0:b0:5a1:1de6:bc66 with SMTP id
 2adb3069b0e04-5a13c93d9e3mr2016793e87.18.1772909791880; Sat, 07 Mar 2026
 10:56:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260307140726.70219-1-dorjoychy111@gmail.com> <20260307140726.70219-2-dorjoychy111@gmail.com>
In-Reply-To: <20260307140726.70219-2-dorjoychy111@gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Sat, 7 Mar 2026 10:56:19 -0800
X-Gm-Features: AaiRm51B7g_JMhlZIdflpWCsx5DmxAmpibsspywnWIGz_sEa1ctulidKDYlHz5s
Message-ID: <CALCETrXVBA9uGEUdQPEZ2MVdxjLwwcWi5kzhOr1NdOWSSRaROw@mail.gmail.com>
Subject: Re: [PATCH v5 1/4] openat2: new OPENAT2_REGULAR flag support
To: Dorjoy Chowdhury <dorjoychy111@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-api@vger.kernel.org, ceph-devel@vger.kernel.org, gfs2@lists.linux.dev, 
	linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, v9fs@lists.linux.dev, 
	linux-kselftest@vger.kernel.org, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	jack@suse.cz, jlayton@kernel.org, chuck.lever@oracle.com, 
	alex.aring@gmail.com, arnd@arndb.de, adilger@dilger.ca, mjguzik@gmail.com, 
	smfrench@gmail.com, richard.henderson@linaro.org, mattst88@gmail.com, 
	linmag7@gmail.com, tsbogend@alpha.franken.de, 
	James.Bottomley@hansenpartnership.com, deller@gmx.de, davem@davemloft.net, 
	andreas@gaisler.com, idryomov@gmail.com, amarkuze@redhat.com, 
	slava@dubeyko.com, agruenba@redhat.com, trondmy@kernel.org, anna@kernel.org, 
	sfrench@samba.org, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	shuah@kernel.org, miklos@szeredi.hu, hansg@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Mar 7, 2026 at 6:09=E2=80=AFAM Dorjoy Chowdhury <dorjoychy111@gmail=
.com> wrote:
>
> This flag indicates the path should be opened if it's a regular file.
> This is useful to write secure programs that want to avoid being
> tricked into opening device nodes with special semantics while thinking
> they operate on regular files. This is a requested feature from the
> uapi-group[1].
>

I think this needs a lot more clarification as to what "regular"
means.  If it's literally

> A corresponding error code EFTYPE has been introduced. For example, if
> openat2 is called on path /dev/null with OPENAT2_REGULAR in the flag
> param, it will return -EFTYPE. EFTYPE is already used in BSD systems
> like FreeBSD, macOS.

I think this needs more clarification as to what "regular" means,
since S_IFREG may not be sufficient.  The UAPI group page says:

Use-Case: this would be very useful to write secure programs that want
to avoid being tricked into opening device nodes with special
semantics while thinking they operate on regular files. This is
particularly relevant as many device nodes (or even FIFOs) come with
blocking I/O (or even blocking open()!) by default, which is not
expected from regular files backed by =E2=80=9Cfast=E2=80=9D disk I/O. Cons=
ider
implementation of a naive web browser which is pointed to
file://dev/zero, not expecting an endless amount of data to read.

What about procfs?  What about sysfs?  What about /proc/self/fd/17
where that fd is a memfd?  What about files backed by non-"fast" disk
I/O like something on a flaky USB stick or a network mount or FUSE?

Are we concerned about blocking open?  (open blocks as a matter of
course.)  Are we concerned about open having strange side effects?
Are we concerned about write having strange side effects?  Are we
concerned about cases where opening the file as root results in
elevated privilege beyond merely gaining the ability to write to that
specific path on an ordinary filesystem?

--Andy
