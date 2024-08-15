Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E2A714A609
	for <linux-cifs@vger.kernel.org>; Thu, 15 Aug 2024 20:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723754857; cv=none; b=R4EVewx9zwYxzwGNLrz2DRH9JUdHvmEGgz1KDGRMSD4NclrrQ1aUK5QE19GbPiGzJzkqBYh0eFT1dK87fmb4H/Ybca6L/su/lWhNZi8oi3il56CLO1cFAsp3Bl+vMx3xD22E09Lik6HEE/O9tvsNGHqZOjJbkF/Glpwhthu9gOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723754857; c=relaxed/simple;
	bh=ZPnBd7Qq2se30H7Q3m74eVMwVWnlRpVvbtIW6arxBII=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MV3nSrf1VkSA9wc0gVyQRlwpK9IplPacySxSlwloe5T6hMRasHVYkYzhPJx14iHdXrkLd+eQ6xJm0BwF4ukw/bF24c6lfa2izlVNjfwbWyZtTqQASJtRHjE2u/nVYtgM7H6FdukhjnoKEZ06pXWH9EsPKgDBl/SI2Gf/zp9J1nM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Yy0D7wmP; arc=none smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Yy0D7wmP"
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-52efc60a6e6so1987304e87.1
        for <linux-cifs@vger.kernel.org>; Thu, 15 Aug 2024 13:47:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723754853; x=1724359653; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=iFmVPOY2gCgSAxYmdyPNIkn1u0495qwY428rI+ytEQQ=;
        b=Yy0D7wmPJlyp7yTPSBN2HpNhubFSg8Kzx31sa0igh/ts0ZeRlCFdiLPM9Gi4qT3N0Q
         B/Hc/ySThcUwyPSqC/sQ5FhppA7nF4Qvtpg1bEFAl7/0TfIkUYkaFioJv3pz7bmxt4HC
         7RDyk/pOBv3MhdO4lQg8xeOQRmF6Yx9Avwxn8N32GaznrxRmIG7Kk8022X1f0A5MGftE
         utAx4inskwvG1wfRJft7rj/uIpv9tim3nX1cmAiAafVmj5SJRYlfIabocf+vo8e9f3XX
         jWl7LyY+ngT4sY8RomTXzUZNsPRWOsF9Cz8LjZA+RbcqbfDQlE1XOHiltR0ub88zDma9
         w53g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723754853; x=1724359653;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iFmVPOY2gCgSAxYmdyPNIkn1u0495qwY428rI+ytEQQ=;
        b=tPk3kI7+ZMCmuzWGRfJxCFg8Sk/corwG2SOSEP1vFFGPAlmfIuiuc/RHXWij4KpQoD
         yNF1GqK+CTMWmgUOqGrP3txHTA3e1wZyn9ynXeSt/A3Jdnt7xvMEWWg+b+AuYU3VH//M
         oz42mp3Sm3zRd+CaPRQKJHdbTfPy/bDv2JIbcgfq/HSrBZEdbnqdGGwvLHFDfgLjkPQ3
         gikI2xGpIl15XwNihkM50XYybjZ/lXkj+YwVXaizPnKYNLEVVi4UzGDbOvhw0hX2NU6g
         bQCw/2JoTexhWqCdYfM6nd8+uO/1yi2FeCL0Ul7dkC6goms5A6rn11KUuMC+sFferT15
         mYNQ==
X-Forwarded-Encrypted: i=1; AJvYcCUiPjpY4xfdLlBD2HsTI40tY5R1PIiADr01rDy6suN6bnY0qBlmzKSGOxMojAX747PGoT9GGDx1ZI0u55uwoHLwyPjWhY09v1xRaA==
X-Gm-Message-State: AOJu0YyLOQtWl0DHuaDkQRZzrrP087dOeYESXKLU/KpqIgMSjMCCawI4
	INfzjBgPgE1HCb6odY1J11TRjMoRq8viv7Cd29cCBncbRefMFP/i5Ax7ohJCBfufNDoC011VXNV
	RbQj4MAO2Rpnjs+pqdOa/B7tyNw8=
X-Google-Smtp-Source: AGHT+IEReakuxwsaxK04MbIloAdUfvYm0z2MlSQ2m8NKI5dep4UY6deMywN87DXogYUHPDqgx46W5VOKG2J6NLca3Gk=
X-Received: by 2002:a05:6512:2204:b0:533:d3e:16fe with SMTP id
 2adb3069b0e04-5331c6d94c1mr347510e87.38.1723754853174; Thu, 15 Aug 2024
 13:47:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <5659539.ZASKD2KPVS@wintermute> <CAH2r5mtzzgG9-peAakYhBNdpahQ=R8wkhJxUQJ+oZtzEvuNjSg@mail.gmail.com>
 <5fad6c05eab959e06fe3518d9104376b79dcbcb9.camel@samba.org>
In-Reply-To: <5fad6c05eab959e06fe3518d9104376b79dcbcb9.camel@samba.org>
From: Steve French <smfrench@gmail.com>
Date: Thu, 15 Aug 2024 15:47:21 -0500
Message-ID: <CAH2r5mt8oV5E4A7RDYr_PLXzDna_Xvg_i1n5bq1vXMY_Mi2=-g@mail.gmail.com>
Subject: Re: Different behavior of POSIX file locks depending on cache mode
To: Andrew Bartlett <abartlet@samba.org>
Cc: Kevin Ottens <kevin.ottens@enioka.com>, linux-cifs@vger.kernel.org, 
	David Howells <dhowells@redhat.com>, Pavel Shilovsky <piastryyy@gmail.com>
Content-Type: multipart/mixed; boundary="000000000000b42c24061fbef306"

--000000000000b42c24061fbef306
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

This (lock_test.cpp) was a nicely done test and turned out to be
fairly easy fix (at least for the write path), and it does help your
test (I will look at the read path next).   David also just reviewed
it so will try to send up to mainline (and Cc: stable) fairly soon.
See attached fix.

Thank you again for narrowing this down.   Your testing with other
less common configs also helped fix two additional problems - SMB1
bugs (these two important fixes went in mainline last month).   After
I finish the patch for the read path I also will see if anything else
missing in the SMB3.1.1 POSIX path (on client or server side - other
than the known Samba server bug with QFSInfo).

    smb3: fix lock breakage for cached writes

    Mandatory locking is enforced for cached writes, which violates
    default posix semantics, and also it is enforced inconsistently.
    This apparently breaks recent versions of libreoffice, but can
    also be demonstrated by opening a file twice from the same
    client, locking it from handle one and writing to it from
    handle two (which fails, returning EACCES).

    Since there was already a mount option "forcemandatorylock"
    (which defaults to off), with this change only when the user
    intentionally specifies "forcemandatorylock" on mount will we
    break posix semantics on write to a locked range (ie we will
    only fail the write in this case, if the user mounts with
    "forcemandatorylock").

    Fixes: 85160e03a79e ("CIFS: Implement caching mechanism for
mandatory brlocks")



On Sun, Jun 9, 2024 at 11:41=E2=80=AFPM Andrew Bartlett <abartlet@samba.org=
> wrote:
>
> (resend due spam rules on list)
>
> Kia Ora Steve,
>
> I'm working with Kevin on this, and I set up a clean environment with
> the latest software to make sure this is all still an issue on current
> software:
>
> I was hoping to include the old SMB1 unix extensions in this test also,
> but these seem unsupported in current kernels.  When did they go away?
>
> Anyway, here is the data.  It certainly looks like an issue with the
> SMB3 client, as only the client changes with the cache=3Dnone
>
> Server is Samba 4.20.1 from Debian Sid.  Kernel is
> Linux debian-sid-cifs-client 6.7.9-amd64 #1 SMP PREEMPT_DYNAMIC Debian
> 6.7.9-2 (2024-03-13) x86_64 GNU/Linux
>
> With SMB1 but not unix extensions (seems unsupported):
>
> root@debian-sid-cifs-client:~# mount.cifs //192.168.122.234/testuser
> mnt -o user=3Dtestuser,pass=3Dpass,vers=3D1.0
> root@debian-sid-cifs-client:~# cd mnt/
> root@debian-sid-cifs-client:~/mnt# ../lock_test foo
> Testing with foo
> Got new file descriptor 3
> Lock set: 1
> Second file descriptor 4
> Read from second fd: x count: 0
> Third file descriptor 5
> Wrote to third fd: 1
>
> root@debian-sid-cifs-client:~# mount.cifs //192.168.122.234/testuser
> mnt -o user=3Dtestuser,pass=3Dpenguin12#,vers=3D3.1.1,posix
> root@debian-sid-cifs-client:~# cd mnt/
> root@debian-sid-cifs-client:~/mnt# ../lock_test foo
> Testing with foo
> Got new file descriptor 3
> Lock set: 1
> Second file descriptor 4
> Read from second fd: x count: -1
> Third file descriptor 5
> Wrote to third fd: -1
> root@debian-sid-cifs-client:~# mount.cifs //192.168.122.234/testuser
> mnt -o user=3Dtestuser,pass=3Dpenguin12#,vers=3D3.1.1,unix
>
> root@debian-sid-cifs-client:~# mount.cifs //192.168.122.234/testuser
> mnt -o user=3Dtestuser,pass=3Dpenguin12#,vers=3D3.1.1,unix,nobrl
> root@debian-sid-cifs-client:~# cd mnt/
> root@debian-sid-cifs-client:~/mnt# ../lock_test foo
> Testing with foo
> Got new file descriptor 3
> Lock set: 1
> Second file descriptor 4
> Read from second fd: o count: 1
> Third file descriptor 5
> Wrote to third fd: 1
>
> And with cache=3Dnone
>
> root@debian-sid-cifs-client:~# mount.cifs //192.168.122.234/testuser
> mnt -o user=3Dtestuser,pass=3Dpenguin12#,vers=3D3.1.1,posix,cache=3Dnone
> root@debian-sid-cifs-client:~# cd mnt/
> root@debian-sid-cifs-client:~/mnt# ../lock_test foo
> Testing with foo
> Got new file descriptor 3
> Lock set: 1
> Second file descriptor 4
> Read from second fd: o count: 1
> Third file descriptor 5
> Wrote to third fd: 1
>
> On Thu, 2024-05-23 at 11:12 -0500, Steve French wrote:
> > What is the behavior with "nobrl" mount option? and what is the
> > behavior when running with the POSIX extensions enabled (e.g. to
> > current Samba or ksmbd adding "posix" to the mount options)
> >
> > On Thu, May 23, 2024 at 11:08=E2=80=AFAM Kevin Ottens <
> > kevin.ottens@enioka.com
> > > wrote:
> > > Hello,
> > >
> > > I've been hunting down a bug exhibited by Libreoffice regarding
> > > POSIX file
> > > locks in conjunction with CIFS mounts. In short: just before
> > > saving, it
> > > reopens a file on which it already holds a file lock (via another
> > > file
> > > descriptor in the same process) in order to read from it to create
> > > a backup
> > > copy... but the read call fails.
> > >
> > > I've been in discussion with Andrew Bartlett for a little while
> > > regarding this
> > > issue and, after exploring several venues, he advised me to send an
> > > email to
> > > this list in order to get more opinions about it.
> > >
> > > The latest discovery we did was that the cache option on the
> > > mountpoint seems
> > > to impact the behavior of the POSIX file locks. I made a minimal
> > > test
> > > application (attached to this email) which basically does the
> > > following:
> > >  * open a file for read/write
> > >  * set a POSIX write lock on the whole file
> > >  * open the file a second time and try to read from it
> > >  * open the file a third time and try to write to it
> > >
> > > It assumes there is already some text in the file. Also, as it goes
> > > it outputs
> > > information about the calls.
> > >
> > > The output I get is the following with cache=3Dstrict on the mount:
> > > ---
> > > Testing with /mnt/foo
> > > Got new file descriptor 3
> > > Lock set: 1
> > > Second file descriptor 4
> > > Read from second fd: x count: -1
> > > Third file descriptor 5
> > > Wrote to third fd: -1
> > > ---
> > >
> > > If I'm using cache=3Dnone:
> > > ---
> > > Testing with /mnt/foo
> > > Got new file descriptor 3
> > > Lock set: 1
> > > Second file descriptor 4
> > > Read from second fd: b count: 1
> > > Third file descriptor 5
> > > Wrote to third fd: 1
> > > ---
> > >
> > > That's the surprising behavior which prompted the email on this
> > > list. Is it
> > > somehow intended that the cache option would impact the semantic of
> > > the file
> > > locks? At least it caught me by surprise and I wouldn't expect such
> > > a
> > > difference in behavior.
> > >
> > > Now, since the POSIX locks are process wide, I would have expected
> > > to have the
> > > output I'm getting for the "cache=3Dnone" case to be also the one I'm
> > > getting
> > > for the "cache=3Dstrict" case.
> > >
> > > I'm looking forward to feedback on this one. I really wonder if we
> > > missed
> > > something obvious or if there is some kind of bug in the cifs
> > > driver.
> > >
> > > Regards.
> > > --
> > > K=C3=A9vin Ottens
> > > kevin.ottens@enioka.com
> > >
> > > +33 7 57 08 95 13
> >
> >
>
> --
>
> Andrew Bartlett (he/him)       https://samba.org/~abartlet/
> Samba Team Member (since 2001) https://samba.org
> Samba Team Lead                https://catalyst.net.nz/services/samba
> Catalyst.Net Ltd
>
> Proudly developing Samba for Catalyst.Net Ltd - a Catalyst IT group
> company
>
> Samba Development and Support: https://catalyst.net.nz/services/samba
>
> Catalyst IT - Expert Open Source Solutions
>
> --
> Andrew Bartlett (he/him)       https://samba.org/~abartlet/
> Samba Team Member (since 2001) https://samba.org
> Samba Team Lead                https://catalyst.net.nz/services/samba
> Catalyst.Net Ltd
>
> Proudly developing Samba for Catalyst.Net Ltd - a Catalyst IT group
> company
>
> Samba Development and Support: https://catalyst.net.nz/services/samba
>
> Catalyst IT - Expert Open Source Solutions



--=20
Thanks,

Steve

--000000000000b42c24061fbef306
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-fix-lock-breakage-for-cached-writes.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-fix-lock-breakage-for-cached-writes.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_lzvr33uf0>
X-Attachment-Id: f_lzvr33uf0

RnJvbSAyNmEzYTVlZDc4M2IwYTVjNDIyNjFiNjA4ZTk1NzIyOWYwMGMxY2VkIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFRodSwgMTUgQXVnIDIwMjQgMTQ6MDM6NDMgLTA1MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiBmaXggbG9jayBicmVha2FnZSBmb3IgY2FjaGVkIHdyaXRlcwoKTWFuZGF0b3J5IGxvY2tp
bmcgaXMgZW5mb3JjZWQgZm9yIGNhY2hlZCB3cml0ZXMsIHdoaWNoIHZpb2xhdGVzCmRlZmF1bHQg
cG9zaXggc2VtYW50aWNzLCBhbmQgYWxzbyBpdCBpcyBlbmZvcmNlZCBpbmNvbnNpc3RlbnRseS4K
VGhpcyBhcHBhcmVudGx5IGJyZWFrcyByZWNlbnQgdmVyc2lvbnMgb2YgbGlicmVvZmZpY2UsIGJ1
dCBjYW4KYWxzbyBiZSBkZW1vbnN0cmF0ZWQgYnkgb3BlbmluZyBhIGZpbGUgdHdpY2UgZnJvbSB0
aGUgc2FtZQpjbGllbnQsIGxvY2tpbmcgaXQgZnJvbSBoYW5kbGUgb25lIGFuZCB3cml0aW5nIHRv
IGl0IGZyb20KaGFuZGxlIHR3byAod2hpY2ggZmFpbHMsIHJldHVybmluZyBFQUNDRVMpLgoKU2lu
Y2UgdGhlcmUgd2FzIGFscmVhZHkgYSBtb3VudCBvcHRpb24gImZvcmNlbWFuZGF0b3J5bG9jayIK
KHdoaWNoIGRlZmF1bHRzIHRvIG9mZiksIHdpdGggdGhpcyBjaGFuZ2Ugb25seSB3aGVuIHRoZSB1
c2VyCmludGVudGlvbmFsbHkgc3BlY2lmaWVzICJmb3JjZW1hbmRhdG9yeWxvY2siIG9uIG1vdW50
IHdpbGwgd2UKYnJlYWsgcG9zaXggc2VtYW50aWNzIG9uIHdyaXRlIHRvIGEgbG9ja2VkIHJhbmdl
IChpZSB3ZSB3aWxsCm9ubHkgZmFpbCB0aGUgd3JpdGUgaW4gdGhpcyBjYXNlLCBpZiB0aGUgdXNl
ciBtb3VudHMgd2l0aAoiZm9yY2VtYW5kYXRvcnlsb2NrIikuCgpGaXhlczogODUxNjBlMDNhNzll
ICgiQ0lGUzogSW1wbGVtZW50IGNhY2hpbmcgbWVjaGFuaXNtIGZvciBtYW5kYXRvcnkgYnJsb2Nr
cyIpCkNjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnCkNjOiBQYXZlbCBTaGlsb3Zza3kgPHBpYXN0
cnl5eUBnbWFpbC5jb20+ClJlcG9ydGVkLWJ5OiBhYmFydGxldEBzYW1iYS5vcmcKUmVwb3J0ZWQt
Ynk6IEtldmluIE90dGVucyA8a2V2aW4ub3R0ZW5zQGVuaW9rYS5jb20+ClJldmlld2VkLWJ5OiBE
YXZpZCBIb3dlbGxzIDxkaG93ZWxsc0ByZWRoYXQuY29tPgpTaWduZWQtb2ZmLWJ5OiBTdGV2ZSBG
cmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+Ci0tLQogZnMvc21iL2NsaWVudC9maWxlLmMg
fCAxMiArKysrKysrKy0tLS0KIDEgZmlsZSBjaGFuZ2VkLCA4IGluc2VydGlvbnMoKyksIDQgZGVs
ZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZnMvc21iL2NsaWVudC9maWxlLmMgYi9mcy9zbWIvY2xp
ZW50L2ZpbGUuYwppbmRleCA0NTQ1OWFmNTA0NGQuLjA0MzhjOTk5ZGVmYyAxMDA2NDQKLS0tIGEv
ZnMvc21iL2NsaWVudC9maWxlLmMKKysrIGIvZnMvc21iL2NsaWVudC9maWxlLmMKQEAgLTI3NTMs
NiArMjc1Myw3IEBAIGNpZnNfd3JpdGV2KHN0cnVjdCBraW9jYiAqaW9jYiwgc3RydWN0IGlvdl9p
dGVyICpmcm9tKQogCXN0cnVjdCBpbm9kZSAqaW5vZGUgPSBmaWxlLT5mX21hcHBpbmctPmhvc3Q7
CiAJc3RydWN0IGNpZnNJbm9kZUluZm8gKmNpbm9kZSA9IENJRlNfSShpbm9kZSk7CiAJc3RydWN0
IFRDUF9TZXJ2ZXJfSW5mbyAqc2VydmVyID0gdGxpbmtfdGNvbihjZmlsZS0+dGxpbmspLT5zZXMt
PnNlcnZlcjsKKwlzdHJ1Y3QgY2lmc19zYl9pbmZvICpjaWZzX3NiID0gQ0lGU19TQihpbm9kZS0+
aV9zYik7CiAJc3NpemVfdCByYzsKIAogCXJjID0gbmV0ZnNfc3RhcnRfaW9fd3JpdGUoaW5vZGUp
OwpAQCAtMjc2OSwxMiArMjc3MCwxNSBAQCBjaWZzX3dyaXRldihzdHJ1Y3Qga2lvY2IgKmlvY2Is
IHN0cnVjdCBpb3ZfaXRlciAqZnJvbSkKIAlpZiAocmMgPD0gMCkKIAkJZ290byBvdXQ7CiAKLQlp
ZiAoIWNpZnNfZmluZF9sb2NrX2NvbmZsaWN0KGNmaWxlLCBpb2NiLT5raV9wb3MsIGlvdl9pdGVy
X2NvdW50KGZyb20pLAorCWlmICgoY2lmc19zYi0+bW50X2NpZnNfZmxhZ3MgJiBDSUZTX01PVU5U
X05PUE9TSVhCUkwpICYmCisJICAgIChjaWZzX2ZpbmRfbG9ja19jb25mbGljdChjZmlsZSwgaW9j
Yi0+a2lfcG9zLCBpb3ZfaXRlcl9jb3VudChmcm9tKSwKIAkJCQkgICAgIHNlcnZlci0+dmFscy0+
ZXhjbHVzaXZlX2xvY2tfdHlwZSwgMCwKLQkJCQkgICAgIE5VTEwsIENJRlNfV1JJVEVfT1ApKQot
CQlyYyA9IG5ldGZzX2J1ZmZlcmVkX3dyaXRlX2l0ZXJfbG9ja2VkKGlvY2IsIGZyb20sIE5VTEwp
OwotCWVsc2UKKwkJCQkgICAgIE5VTEwsIENJRlNfV1JJVEVfT1ApKSkgewogCQlyYyA9IC1FQUND
RVM7CisJCWdvdG8gb3V0OworCX0gZWxzZQorCQlyYyA9IG5ldGZzX2J1ZmZlcmVkX3dyaXRlX2l0
ZXJfbG9ja2VkKGlvY2IsIGZyb20sIE5VTEwpOworCiBvdXQ6CiAJdXBfcmVhZCgmY2lub2RlLT5s
b2NrX3NlbSk7CiAJbmV0ZnNfZW5kX2lvX3dyaXRlKGlub2RlKTsKLS0gCjIuNDMuMAoK
--000000000000b42c24061fbef306--
