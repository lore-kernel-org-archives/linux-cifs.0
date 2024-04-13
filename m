Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29AC715E89
	for <linux-cifs@vger.kernel.org>; Sat, 13 Apr 2024 16:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713026354; cv=none; b=MxRUIUlQOcd+VZJDbsZoks11053v+GvaPznfFIg1/t+Zeisk2qDoP2XvxDl74xhd/DdZzVND5gde4h+FEMOX5DCOJQ2E79yaqMLroBFJBakcheymk6+a4wYCHYci+8rl6ds3gR8hfVA2TJodcc08Rk7k+A2+spoEV5A0xr3BKmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713026354; c=relaxed/simple;
	bh=vMj3++Og8hrN6nGSDD+RJKW0mynhe+wYIax8ZKfEdCI=;
	h=Content-Type:Message-ID:Date:MIME-Version:Subject:To:References:
	 From:Cc:In-Reply-To; b=NWtd0YGKplUAmbDibUhpAPw2VH+alWWYvI3muRByg5GVIgcMhj4j482aE0VifGrxg9I+WL9q0896r9tHdn9484dPK4GdgJzE9g2aAxGM9SMOP+gOi1TQxHsn0eIy1No8SdhgYB94g3AFRGZwtEnNCqeNS/bbmt2iU30sZY/Ev28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=draigBrady.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eobUU28O; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=draigBrady.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eobUU28O"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-343c891bca5so1157265f8f.2
        for <linux-cifs@vger.kernel.org>; Sat, 13 Apr 2024 09:39:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713026350; x=1713631150; darn=vger.kernel.org;
        h=in-reply-to:cc:from:references:to:content-language:subject
         :user-agent:mime-version:date:message-id:sender:from:to:cc:subject
         :date:message-id:reply-to;
        bh=knRFJoh5OGoSbun8MYPwjrWHJZ8UrXl1ibNK7Szz5ZU=;
        b=eobUU28O9AJO2kHCaviJEtbBwrnlR8/E8RTfQs8qQUwXTMNS6fJNnYQ/kpQM0LFQ/G
         HNx6FFTxviuE8MFIhwetg8ADo/X0X+aCZMA0bMhjo1KDqwoN2t5QBANTxP0D3a2fqKqD
         FatTr7o/VgQrhhQ38cnUeYKm4rRlgOh82VGMEAtqGrfQUMEspiBjvfgLBf6W98VM1KlP
         THKnUMU9sEWwt8h+NaL3bx8Qoqpn6fHVN4YZEAYPnLoLb+6efcEl7vHdEGyI7P/fBKXA
         WDLmBug1ulnyTlzpJ5nfdnzOffn1oPEeR1omNtO/25z4tSZN2AXPJRiE+3W+XrPoxmsl
         tRBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713026350; x=1713631150;
        h=in-reply-to:cc:from:references:to:content-language:subject
         :user-agent:mime-version:date:message-id:sender:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=knRFJoh5OGoSbun8MYPwjrWHJZ8UrXl1ibNK7Szz5ZU=;
        b=pPzQ3z8WkrnkHnVfPwUkLbn5GpdZ1ovDO9P4zhHcBE/k+CXXpOTLE5J2wsaY25ResK
         DYQQ8pB95bjAPTBiZ3tJD1/pTxkSzTMDGniEZrZxC9X/cKW0/+OtrIB1F1bFAWF4NWYq
         tYxaIoXpp/bnsyB0Lwv4vMNg61tP9Sp0FHRLVolvv7jk7+6/JSNvYc8WB9yGwRtOYNg/
         AECAe80sIopGVe6mF+K/z0jIQrAGuedGgrwF1OvHH3BlqQjHkNhOqu57ZhsLDL4Q1opd
         6AP5uBKH3Dl+piLh52hOcpvIZbreynKyPzVawIxNZhYZH3kEK9v0jZeWfY6C2ykFAywm
         lOdQ==
X-Forwarded-Encrypted: i=1; AJvYcCU/kw4L5JJwgR4R2SwozIKs0ndbTnBekmaEMIa9un7Lh4+pm55ryy+sIu2ehy6r8Pk+y1mZN8VsBVvyS0wneQSZ5+0fGK6i6B1h3w==
X-Gm-Message-State: AOJu0Yzl1b6JL5N0lUw2JVEG/UjvFKJRzed9vXHQaUIbabWOAWmmiE13
	hexKjt4JdwXn8/uNzP5tu/GAaq9eR3uVmc2mCP0sFZmKd9URjhn/yUsPsQ==
X-Google-Smtp-Source: AGHT+IHabx+k3tzEoNYYpQ03rmsGgOGzU9f9vULWpEk98okXL/YZEgGo/8Ij93gsm/zwEVmrmG68Gg==
X-Received: by 2002:a5d:59a5:0:b0:343:41ef:ab30 with SMTP id p5-20020a5d59a5000000b0034341efab30mr5622243wrr.47.1713026350201;
        Sat, 13 Apr 2024 09:39:10 -0700 (PDT)
Received: from [192.168.1.53] (86-44-211-146-dynamic.agg2.lod.rsl-rtd.eircom.net. [86.44.211.146])
        by smtp.googlemail.com with ESMTPSA id n12-20020adfe78c000000b00343723c126asm6901056wrm.48.2024.04.13.09.39.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 13 Apr 2024 09:39:09 -0700 (PDT)
Sender: =?UTF-8?Q?P=C3=A1draig_Brady?= <pixelbeat@gmail.com>
Content-Type: multipart/mixed; boundary="------------dYYnLbH9v0yokecJ9Tj0uYli"
Message-ID: <cdd87faf-a769-35c8-31ce-a1bf016cbe3e@draigBrady.com>
Date: Sat, 13 Apr 2024 17:39:07 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: bug#70214: 'install' fails to copy regular file to autofs/cifs,
 due to ACL or xattr handling
Content-Language: en-US
To: Bruno Haible <bruno@clisp.org>, 70214@debbugs.gnu.org
References: <6127852.nNyiNAGI2d@nimes>
From: =?UTF-8?Q?P=C3=A1draig_Brady?= <P@draigBrady.com>
Cc: Andreas Gruenbacher <andreas.gruenbacher@gmail.com>,
 "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
In-Reply-To: <6127852.nNyiNAGI2d@nimes>

This is a multi-part message in MIME format.
--------------dYYnLbH9v0yokecJ9Tj0uYli
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 05/04/2024 10:48, Bruno Haible wrote:
> Hi,
> 
> The 'install' program from coreutils-9.5 fails to copy a regular file
> from an ext4 mount to an autofs/cifs mount.
> 
> The same operation, with 'cp -a', works fine.
> 
> Also, it works fine when coreutils was built with the configure options
> "--disable-acl --disable-xattr".
> 
> How to reproduce
> ================
> 
> 1) On the machine sparcdev.matoro.tk (Linux 6.8.2), I built coreutils-9.5
> from source,
>    - once with default options, in build-sparc64/,
>    - once with "--disable-acl --disable-xattr", in build-sparc64-no-acl/.
> 
> 2) Create a regular file on an ext4 mount:
> 
> $ echo hi > /var/tmp/foo3941
> $ ls -lZ /var/tmp/foo3941
> -rw-r----- 1 g-haible g-haible ? 3 Apr  4 13:29 /var/tmp/foo3941
> $ getfacl /var/tmp/foo3941
> getfacl: Removing leading '/' from absolute path names
> # file: var/tmp/foo3941
> # owner: g-haible
> # group: g-haible
> user::rw-
> group::r--
> other::---
> $ df -m /var/tmp/
> Filesystem     1M-blocks   Used Available Use% Mounted on
> /dev/root         560245 123140    408574  24% /
> $ mount | grep ' / '
> /dev/sda2 on / type ext4 (rw,noatime)
> 
> 3) Details about the destination directory:
> 
> $ echo $HOME
> /media/guest-homedirs/haible
> $ mount | grep /media/guest-homedirs/haible
> /etc/autofs/auto.guest-homedirs on /media/guest-homedirs/haible type autofs (rw,relatime,fd=7,pgrp=2325,timeout=60,minproto=5,maxproto=5,direct,pipe_ino=46092)
> //syslog.matoro.tk/guest-haible on /media/guest-homedirs/haible type cifs (rw,nosuid,relatime,vers=1.0,cache=strict,username=nobody,uid=30014,forceuid,gid=30014,forcegid,addr=fd05:0000:0000:0000:0000:0000:0000:0001,soft,unix,posixpaths,serverino,mapposix,acl,rsize=1048576,wsize=65536,bsize=1048576,retrans=1,echo_interval=60,actimeo=1,closetimeo=1)
> 
> 4) The operation that fails:
> 
> $ build-sparc64/src/ginstall -c /var/tmp/foo3941 $HOME/foo3941; echo $?
> build-sparc64/src/ginstall: setting permissions for '/media/guest-homedirs/haible/foo3941': Permission denied
> 1
> $ build-sparc64-no-acl/src/ginstall -c /var/tmp/foo3941 $HOME/foo3941; echo $?
> 0
> 
> 5) The same thing with 'cp -a' succeeds:
> 
> $ build-sparc64/src/cp -a /var/tmp/foo3941 $HOME/foo3941; echo $?
> 0
> $ build-sparc64-no-acl/src/cp -a /var/tmp/foo3941 $HOME/foo3941; echo $?
> 0
> 
> 6) 'strace' shows a failing call to fsetxattr:
> 
> $ strace build-sparc64/src/ginstall -c /var/tmp/foo3941 $HOME/foo3941

> fsetxattr(4, "system.posix_acl_access", "\2\0\0\0\1\0\6\0\377\377\377\377\4\0\0\0\377\377\377\377 \0\0\0\377\377\377\377", 28, 0) = -1 EACCES (Permission denied)
> fchmod(4, 0600)                         = 0

> Notes
> =====
> 
> The 'cp' program does *not* use fsetxattr() calls on the destination file
> descriptor and therefore does not fail:
> 
> $ strace build-sparc64/src/cp -a /var/tmp/foo3941 $HOME/foo3941

> flistxattr(3, NULL, 0)                  = 0
> flistxattr(3, 0x7feff9860a0, 0)         = 0
> fchmod(4, 0100640)                      = 0
> flistxattr(3, NULL, 0)                  = 0
> flistxattr(3, 0x7feff9860c0, 0)         = 0

> As you can see, it uses 4 flistxattr() calls on the source file descriptor,
> apparently detecting that it's a regular file without ACLs, and proceeds to
> do a simple fchmod() call on the destination file descriptor.
> 
> Probably the same logic is needed in the 'install' program.

install(1) defaults to mode 600 for new files, and uses set_acl() with that
(since 2007 https://github.com/coreutils/coreutils/commit/f634e8844 )
The psuedo code that install(1) uses is:

copy_reg()
   if (x->set_mode) /* install */
     set_acl(dest, x->mode /* 600 */)
       ctx->acl = acl_from_mode ( /* 600 */)
       acl_set_fd (ctx->acl) /* fails EACCES */
       if (! acls_set)
          must_chmod = true;
       if (must_chmod)
         saved_errno = EACCES;
         chmod (ctx->mode /* 600 */)
         if (save_errno)
           return -1;

This issue only only seems to be on CIFS.
I'm seeing lot of weird behavior with ACLs there:

   acl_set_fd (acl_from_mode (600)) -> EACCES
   acl_set_fd (acl_from_mode (755)) -> EINVAL
   getxattr ("system.posix_acl_access") -> EOPNOTSUPP

Note we ignore EINVAL and EOPNOTSUPP errors in set_acl(),
and it's just the EACCES that's problematic.
Note this is quite similar to https://debbugs.gnu.org/65599
where Paul also noticed EACCES with fsetxattr() (and others) on CIFS.

The attached is a potential solution which I tested as working
on the same matoro system that Bruno used.

I think I'll apply that after thinking a bit more about it.

cheers,
Pádraig.
--------------dYYnLbH9v0yokecJ9Tj0uYli
Content-Type: text/x-patch; charset=UTF-8; name="gnulib-set-acl-cifs.patch"
Content-Disposition: attachment; filename="gnulib-set-acl-cifs.patch"
Content-Transfer-Encoding: base64

RnJvbSBkODI4ZDk2NTZjM2JkMWRkZjBmY2RkYjU3OGRkYjJlZDlhNGQzNzAxIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiA9P1VURi04P3E/UD1DMz1BMWRyYWlnPTIwQnJhZHk/
PSA8UEBkcmFpZ0JyYWR5LmNvbT4KRGF0ZTogU2F0LCAxMyBBcHIgMjAyNCAxNzoxMzowMiAr
MDEwMApTdWJqZWN0OiBbUEFUQ0hdIGFjbC1wZXJtaXNzaW9uczogYXZvaWQgZXJyb25lb3Vz
IGZhaWx1cmUgb24gQ0lGUwoKKiBsaWIvc2V0LXBlcm1pc3Npb25zLmMgKHNldF9hY2xzKTog
T24gTGludXggYWxzbyBkaXNjb3VudApFQUNFU1MgYXMgYSB2YWxpZCBlcnJubyB3aXRoIEZE
IG9wZXJhdGlvbnMsIGFzIENJRlMgd2FzIHNlZW4gdG8KcmV0dXJuIHRoYXQgZXJyb25lb3Vz
bHkgaW4gc29tZSBjYXNlcy4KLS0tCiBDaGFuZ2VMb2cgICAgICAgICAgICAgfCA3ICsrKysr
KysKIGxpYi9zZXQtcGVybWlzc2lvbnMuYyB8IDggKysrKysrKy0KIDIgZmlsZXMgY2hhbmdl
ZCwgMTQgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQoKZGlmZiAtLWdpdCBhL0NoYW5n
ZUxvZyBiL0NoYW5nZUxvZwppbmRleCBjNzIxNjVlMjY4Li5mZDA5NGQxMDkxIDEwMDY0NAot
LS0gYS9DaGFuZ2VMb2cKKysrIGIvQ2hhbmdlTG9nCkBAIC0xLDMgKzEsMTAgQEAKKzIwMjQt
MDQtMTMgIFDDoWRyYWlnIEJyYWR5ICA8UEBkcmFpZ0JyYWR5LmNvbT4KKworCWFjbC1wZXJt
aXNzaW9uczogYXZvaWQgZXJyb25lb3VzIGZhaWx1cmUgb24gQ0lGUworCSogbGliL3NldC1w
ZXJtaXNzaW9ucy5jIChzZXRfYWNscyk6IE9uIExpbnV4IChhbmQgb3RoZXJzKSwgYWxzbyBk
aXNjb3VudAorCUVBQ0VTUyBhcyBhIHZhbGlkIGVycm5vIHdpdGggRkQgb3BlcmF0aW9ucywg
YXMgQ0lGUyB3YXMgc2VlbiB0bworCXJldHVybiB0aGF0IGVycm9uZW91c2x5IGluIHNvbWUg
Y2FzZXMuCisKIDIwMjQtMDQtMTMgIEJydW5vIEhhaWJsZSAgPGJydW5vQGNsaXNwLm9yZz4K
IAogCWdudWxpYi10b29sLnB5OiBDb2RlIHR3ZWFrLgpkaWZmIC0tZ2l0IGEvbGliL3NldC1w
ZXJtaXNzaW9ucy5jIGIvbGliL3NldC1wZXJtaXNzaW9ucy5jCmluZGV4IDgzYTM1NWZhYTUu
LjdmOGU1NWY1Y2QgMTAwNjQ0Ci0tLSBhL2xpYi9zZXQtcGVybWlzc2lvbnMuYworKysgYi9s
aWIvc2V0LXBlcm1pc3Npb25zLmMKQEAgLTUyMCw3ICs1MjAsMTMgQEAgc2V0X2FjbHMgKHN0
cnVjdCBwZXJtaXNzaW9uX2NvbnRleHQgKmN0eCwgY29uc3QgY2hhciAqbmFtZSwgaW50IGRl
c2MsCiAgICAgICAgICAgICByZXQgPSBhY2xfc2V0X2ZpbGUgKG5hbWUsIEFDTF9UWVBFX0FD
Q0VTUywgY3R4LT5hY2wpOwogICAgICAgICAgIGlmIChyZXQgIT0gMCkKICAgICAgICAgICAg
IHsKLSAgICAgICAgICAgICAgaWYgKCEgYWNsX2Vycm5vX3ZhbGlkIChlcnJubykpCisgICAg
ICAgICAgICAgIGlmICghIGFjbF9lcnJub192YWxpZCAoZXJybm8pCisjICAgaWYgZGVmaW5l
ZCBfX2xpbnV4X18KKyAgICAgICAgICAgICAgICAgIC8qIFNwZWNpYWwgY2FzZSBFQUNDRVMg
Zm9yIGZkIG9wZXJhdGlvbnMgYXMgQ0lGUworICAgICAgICAgICAgICAgICAgICAgd2FzIHNl
ZW4gdG8gZXJyb25lb3VzbHkgcmV0dXJuIHRoYXQgaW4gc29tZSBjYXNlcy4gICovCisgICAg
ICAgICAgICAgICAgICB8fCAoSEFWRV9BQ0xfU0VUX0ZEICYmIGRlc2MgIT0gLTEgJiYgZXJy
bm8gPT0gRUFDQ0VTKQorIyAgIGVuZGlmCisgICAgICAgICAgICAgICAgICkKICAgICAgICAg
ICAgICAgICB7CiAgICAgICAgICAgICAgICAgICBjdHgtPmFjbHNfbm90X3N1cHBvcnRlZCA9
IHRydWU7CiAgICAgICAgICAgICAgICAgICBpZiAoZnJvbV9tb2RlIHx8IGFjbF9hY2Nlc3Nf
bm9udHJpdmlhbCAoY3R4LT5hY2wpID09IDApCi0tIAoyLjQ0LjAKCg==

--------------dYYnLbH9v0yokecJ9Tj0uYli--
