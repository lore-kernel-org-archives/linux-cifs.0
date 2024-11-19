Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9D0F27735
	for <linux-cifs@vger.kernel.org>; Tue, 19 Nov 2024 02:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731984708; cv=none; b=OUE5aMscBRDfePlY1xnI0qIDbLbyYL0gME0HNV6/5zPCUk2IT0okxOeVplQJxVoFT6Eny5lzv4tXI8IRung10h6oE32IcFMBAhl5XTIwHbAW8U3juCI5KZmZJyW/WpqSCMuMqmv4YyBqBcJEmnm8dQK3jtAQ7/iR/NYsDatBqAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731984708; c=relaxed/simple;
	bh=y35UV0cuK6FwjgUaTebgKgiLFDnrYNixnk3DmwylJE8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Qre1+GQZxAubR/fGVgUQhlxjwy07oMrz8CexHoYrpiZeszF8fpyxrCJZvx2ekWdBwIvu2CPlWxTuaXiXbcyDqd9k2PrFyIvAnBGMbwluJHXIdNbtui0uUMI0ivvEt5/6OjNRKix3FvrOZyUH/iF6Td/KpjO936L4TcePJpyHr2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AMbOAbBn; arc=none smtp.client-ip=209.85.208.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AMbOAbBn"
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-2fb5fa911aaso36007771fa.2
        for <linux-cifs@vger.kernel.org>; Mon, 18 Nov 2024 18:51:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731984705; x=1732589505; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=WYLRZxurmyKbuKnEbc7UpIdgi3ScMIe+s7ynUr9tekw=;
        b=AMbOAbBn0R7hJFguU92WxM6oWLkKXahgPukupbUi8WMkp5P7bOfNdjCu1skammDhnk
         egCxyDhncv15LW7x1/qYUQu8VquD0qmHfWY9z9nTAUr4T8D0rs4O4V6CFNFsXz5oOj+v
         CvStgq3q6RbgH5cg/D5xkHxKKiJI0A4dRS7nuQx4A69xVMG+AC35GHBlScHLg6FKDQHH
         OIpm+z2AAzxRn6hRCadLhUOs40Xh4WyttBRdgTPFRzf04bk8eRqFpP/78J0R2/Iko4JY
         m1UZIUkPRvFDySpZr05SYt6jOGXPGUt7/Ab4GzAx7GH0azVMqDPMk9Bd/NCHOnTuPUrs
         dX9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731984705; x=1732589505;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WYLRZxurmyKbuKnEbc7UpIdgi3ScMIe+s7ynUr9tekw=;
        b=n+tztEwTSE9smI2fBsHibOMkF1I4/X3/Sve9pEHHECqq2kzwNMPZTP0+I3zlFDo1I2
         MzBTwBrYD8n9etgHQ9Evw1c5qLuQ9KkmlkL2R48K1yomB1I9wc4ahIHPTYDX6qCNMlzl
         C+m5Oez3XGTDNoYnFsdaTty/552ekT1oG/UQNr94bzl9y4YuO+2V8mMIBwVqZ4ECZj6H
         ygwV3O2iErMr8EyGIJqiCwpEeXwQNuaQ4zX20iqhENJripo9d0C93kb+6UyLEoECccfo
         pB4Nzg0Ry8R2dtX6uNzIdv/EjfFkJSXXuGZ3Lz99N7I/v8yvKSGYFvINoEMD8JOc1YW8
         doQw==
X-Gm-Message-State: AOJu0YwyWfpEFce920sZ/IBv2dF7GlWWVHTTIctQKG1tVCCc5fDTxuG6
	4rrw2+OWEiirAvIBR3Xk/0kYsRoz927uPFLJYJ8hOuFs7CRz/5vYZLcWc5XscWnWGRkJUBgrUPE
	tDIMGUseLZtueEvG2V6iUSPFbJ38=
X-Google-Smtp-Source: AGHT+IH1awMl0Ktbxi5k2oYi6WDO7B5ue3pc3Fz4MZ5LCpRT9rfAEAUyNeKRlMFg7+HBtOXxiO0poKhI6jNnZUHyhZU=
X-Received: by 2002:a2e:b8c6:0:b0:2fb:2a96:37fd with SMTP id
 38308e7fff4ca-2ff606dbc79mr105283611fa.29.1731984704581; Mon, 18 Nov 2024
 18:51:44 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <113d44d8-35a4-452e-9931-aca00c2237d0@samba.org>
 <CAH2r5muwuKvifnG0XK3wShCtpR6EZOEozn=H95qx9ewHDO5jdA@mail.gmail.com>
 <42c8b091-a57a-4d4e-aebf-aee57dabf5d4@samba.org> <CAH2r5mtr0SJHzG4tNeRA=1H1gEswQUywj0G5kR+wuoPk1r1YVA@mail.gmail.com>
 <6e38eeba-9a82-48f4-bfcd-a4f2ce718782@samba.org>
In-Reply-To: <6e38eeba-9a82-48f4-bfcd-a4f2ce718782@samba.org>
From: Steve French <smfrench@gmail.com>
Date: Mon, 18 Nov 2024 20:51:33 -0600
Message-ID: <CAH2r5mtGx9w+=qcY9zVwaJXWDC=4w1nFn4WNx1DC6vnjvDV3UA@mail.gmail.com>
Subject: Re: Directory Leases
To: Ralph Boehme <slow@samba.org>
Cc: linux-cifs@vger.kernel.org, 
	Meetakshi Setiya <meetakshisetiyaoss@gmail.com>, ronnie sahlberg <ronniesahlberg@gmail.com>
Content-Type: multipart/mixed; boundary="00000000000012f2e206273b1dbf"

--00000000000012f2e206273b1dbf
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Here is a one line patch to make sure we request HANDLE leases on
cached directories.
I also want to make sure (in followon patch) that we check in the open
response (ie the lease
state granted) that we don't defer close of directory if we don't get
both HANDLE and READ
in response.


On Tue, Oct 29, 2024 at 5:05=E2=80=AFAM Ralph Boehme <slow@samba.org> wrote=
:
>
> Hi Steve,
>
> On 10/28/24 10:11 PM, Steve French wrote:
> > Doing some additional experiments to Windows and also to the updated
> > Samba branch from Ralph, I see the directory lease request, and
> > I see that after ls (which will cache the directory contents for about
> > 30 second) we do get a big benefit from the metadata of the directory
> > entries being cached e.g. "ls /mnt ; sleep 10; stat /mnt/file ; sleep
> > 15 stat /mnt/file2 ; sleep 10 /mnt/file"  - we only get the roundtrips
> > for the initial ls - the stat calls don't cause any network traffic
> > since the directory is cached.
> indeed, I can confirm that some cache is used for stat. Unfortunately it
> isn't used for readddir.
>
> Also, coming back on the issue that the client is deferring a close on
> the directory with having a H lease:
>
> In my understanding that's at least going to cause problems if other
> clients want to do anything on the server that is not allowed if there
> are conflicting opens like renaming a directory (which is not allowed if
> there are any opens below recursively). Unlinks will also be deferred as
> long as the client sticks to its handle.
>
> The client should acquire a RH lease on directories if it wants to cache
> the handle and that's a prerequisite in order to cache readdir.
>
> Afair the kernel is currently caching for 30 seconds. Increasing this
> time should not be done without also having a H lease.
>
> -slow



--
Thanks,

Steve

--00000000000012f2e206273b1dbf
Content-Type: application/x-patch; 
	name="0001-smb3-request-handle-caching-when-caching-directories.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-request-handle-caching-when-caching-directories.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_m3nczq0z0>
X-Attachment-Id: f_m3nczq0z0

RnJvbSBmZWMxNDEyOGVmM2E4OTFlMTk0MDY2ZmVkYmU0NWUyZDIzZjMyM2Q5IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IE1vbiwgMTggTm92IDIwMjQgMTI6MTk6NDYgLTA2MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiByZXF1ZXN0IGhhbmRsZSBjYWNoaW5nIHdoZW4gY2FjaGluZyBkaXJlY3RvcmllcwoKVGhp
cyBjbGllbnQgd2FzIG9ubHkgcmVxdWVzdGluZyBSRUFEIGNhY2hpbmcsIG5vdCBSRUFEIGFuZCBI
QU5ETEUgY2FjaGluZwppbiB0aGUgTGVhc2VTdGF0ZSBvbiB0aGUgb3BlbiByZXF1ZXN0cyB3ZSBz
ZW5kIGZvciBkaXJlY3Rvcmllcy4gIFRvCmRlbGF5IGNsb3NpbmcgYSBoYW5kbGUgKGUuZy4gZm9y
IGNhY2hpbmcgZGlyZWN0b3J5IGNvbnRlbnRzKSB3ZSBzaG91bGQKYmUgcmVxdWVzdGluZyBIQU5E
TEUgYXMgd2VsbCBhcyBSRUFEIChhcyB3ZSBhbHJlYWR5IGRvIGZvciBkZWZlcnJlZApjbG9zZSBv
ZiBmaWxlcykuICAgU2VlIE1TLVNNQjIgMy4zLjEuNCBlLmcuCgpDYzogc3RhYmxlQHZnZXIua2Vy
bmVsLm9yZwpTaWduZWQtb2ZmLWJ5OiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5j
b20+Ci0tLQogZnMvc21iL2NsaWVudC9zbWIyb3BzLmMgfCAyICstCiAxIGZpbGUgY2hhbmdlZCwg
MSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkKCmRpZmYgLS1naXQgYS9mcy9zbWIvY2xpZW50
L3NtYjJvcHMuYyBiL2ZzL3NtYi9jbGllbnQvc21iMm9wcy5jCmluZGV4IDZjNGE3MzM1YThhMi4u
ZmE5NmViZWQ4MzEwIDEwMDY0NAotLS0gYS9mcy9zbWIvY2xpZW50L3NtYjJvcHMuYworKysgYi9m
cy9zbWIvY2xpZW50L3NtYjJvcHMuYwpAQCAtNDA0OSw3ICs0MDQ5LDcgQEAgbWFwX29wbG9ja190
b19sZWFzZSh1OCBvcGxvY2spCiAJaWYgKG9wbG9jayA9PSBTTUIyX09QTE9DS19MRVZFTF9FWENM
VVNJVkUpCiAJCXJldHVybiBTTUIyX0xFQVNFX1dSSVRFX0NBQ0hJTkdfTEUgfCBTTUIyX0xFQVNF
X1JFQURfQ0FDSElOR19MRTsKIAllbHNlIGlmIChvcGxvY2sgPT0gU01CMl9PUExPQ0tfTEVWRUxf
SUkpCi0JCXJldHVybiBTTUIyX0xFQVNFX1JFQURfQ0FDSElOR19MRTsKKwkJcmV0dXJuIFNNQjJf
TEVBU0VfUkVBRF9DQUNISU5HX0xFIHwgU01CMl9MRUFTRV9IQU5ETEVfQ0FDSElOR19MRTsKIAll
bHNlIGlmIChvcGxvY2sgPT0gU01CMl9PUExPQ0tfTEVWRUxfQkFUQ0gpCiAJCXJldHVybiBTTUIy
X0xFQVNFX0hBTkRMRV9DQUNISU5HX0xFIHwgU01CMl9MRUFTRV9SRUFEX0NBQ0hJTkdfTEUgfAog
CQkgICAgICAgU01CMl9MRUFTRV9XUklURV9DQUNISU5HX0xFOwotLSAKMi40My4wCgo=
--00000000000012f2e206273b1dbf--
