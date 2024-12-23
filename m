Received: from mail-yb1-f182.google.com (mail-yb1-f182.google.com [209.85.219.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B306EEB5
	for <linux-cifs@vger.kernel.org>; Mon, 23 Dec 2024 08:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734941564; cv=none; b=fM3EelE+N4ja9fGFGeQhmPFYqyc4txq8qHST/EXwmrg9UHs5LnRZ+Zg5p52+BFtPHxqcYjZX/p71qf90jHhksMNKLNXZkJslWzkcq9EyCmcjnfEsg5WuaCJ5MNKNPBaUc5nUiD8MmCDzcp4sN/q7cK8LUE5N5ohticsVphTaxCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734941564; c=relaxed/simple;
	bh=JteOWFk5ZyKeD7RxsMFAc+tnVcNEizpPWB2m9rUjgVE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=oxt7wMd/+ab76FZyiPXCoXksoWBwlV1wsD3t9j+9vFFgYtzE5n6uezFMz73UldeYDA6RxDMRKe6TMvbVv2y7amIyGM3jIRB0fPHdkr/7jnLndLtjxkPsZ0yehYUPMbRZg0IgcoafAniwb2DPz8oQ2n0gGBsdas9GBLDZ1pWQ6D0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BK0fRE+B; arc=none smtp.client-ip=209.85.219.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BK0fRE+B"
Received: by mail-yb1-f182.google.com with SMTP id 3f1490d57ef6-e3fd6cd9ef7so3894515276.1
        for <linux-cifs@vger.kernel.org>; Mon, 23 Dec 2024 00:12:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734941561; x=1735546361; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BcfE8fJ35Ps7w9P1+ulvqBvPg71/ddEKbiRIcLw0Gk0=;
        b=BK0fRE+BBwXNAad7kk9viTHFY53J1YDmya1lDs190B2I/4zEK+QSDvgN6UtLxJC2l8
         nF/I0LhtdDBLdDHt9jkNf4VIup18svz97sdNHOXV/4vlvPQ/fhB7uPYVwvWgQM7zN1Ym
         6G3Gh48Nq2jUHJISkDBJOErG6BLyg9gtlIVTA6p6XMPioG9/1+oftZ1zpcaLXbj7GySf
         firNhMs8N9IkRHxmhiIu5lX31BE68vEmtZxXHMVuFuvJ7C6Kd6uMDg7Q3P5ZkrsrEVbb
         Yi1HY2pV7cKzn0fBoNNO4aphOrcShfTd2mm/Klmjmuy0z1wO9QYGhT5IHe1FFJnW0yT3
         67KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734941561; x=1735546361;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BcfE8fJ35Ps7w9P1+ulvqBvPg71/ddEKbiRIcLw0Gk0=;
        b=IY7Gi0ywxp0oXqMX5EUjJVDOAfcj42AnwCS94cIng9jmUNXS8t7BkSxotflxLWZyl2
         2WTpXVGHoVq+QHQ4XTXi4fCxifiyW5+5Shi/tzegP0QxOjMc1LLUONiqLeJOazcglnpI
         KxxzkDtvCZBASfB9qzpiekY2uTwjNRHmUJpuTgW4zTbFi8iNSeB1npbeFkviEg67+8kC
         8RtmLsTnhb0/q5jwR/Pg2H2ml8wo5s7VqpjD3WQsJZAiH2BXDVACBs5YGITm9c5zO2IP
         bnLPX2P6wLKrqL/pclo3sGOtI2Feqi67C+DMfMxOj/jb+Nj0h7U0J+iV7UZh9FKC/jDr
         9vbw==
X-Forwarded-Encrypted: i=1; AJvYcCXHzdh/OqL24g4kiTUzMkAk3QQlSntKKhi+aT1XNB1JmxnfXnDK2UQzm62LmZnaD5y46Jn/t8gQZOys@vger.kernel.org
X-Gm-Message-State: AOJu0YxJaBSqiFgFi2AGsBVRdnnczCQp8hZR5W31PLq6lxHUQtGPW6fK
	i1C7DWN/v9Sf/IVBsMS2eXcl/qfMQN/QGMYUogD3M3uY0YcAtTlqrBsI5qQyKNhF70iH58AjTVj
	nmJ9gGnRmswLXAOueoyDO/yzoWOg=
X-Gm-Gg: ASbGncst7F4Z6SGUhmGjz9byUgELRDIyuT7OgqaB/gVPIavxH8MkQrTRFby25Qtxkzn
	B54HVIAtU0uUD8XlXZ3T04JPoa47YnVLMnapyQ2EoAhNRttq1RKlsp9YsZZAhvtgIzys7
X-Google-Smtp-Source: AGHT+IFdN+4MGkVUUx+Jc3NTVJFfUPLaY03Q9axW/CXlHIIqUEkMYMkUYuFOiuunJ/dNdjlMxr0QQI8kIXght+vwhd4=
X-Received: by 2002:a05:6902:1ac8:b0:e4c:456b:19de with SMTP id
 3f1490d57ef6-e538ce5895amr9118106276.16.1734941560667; Mon, 23 Dec 2024
 00:12:40 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241216183148.4291-1-bharathsm@microsoft.com>
 <CAH2r5mumh1xU8zAdE9sqmgGN11sY=HedD-PpdqCvR3BTod1NwQ@mail.gmail.com>
 <CANT5p=rYjgbteSBRuZFfXYwC-g6QLMG20250RzO9Es8GZPeL2g@mail.gmail.com> <Z2SijUfZWp37R2Do@haley.home.arpa>
In-Reply-To: <Z2SijUfZWp37R2Do@haley.home.arpa>
From: Bharath SM <bharathsm.hsk@gmail.com>
Date: Mon, 23 Dec 2024 13:42:29 +0530
Message-ID: <CAGypqWxW-tG9omw7+s=DK89KPs+RFDFneYUKa2ZqjZ0yJkjbAw@mail.gmail.com>
Subject: Re: [PATCH] smb: enable reuse of deferred file handles for write operations
To: Shyam Prasad N <nspmangalore@gmail.com>, Steve French <smfrench@gmail.com>, 
	Bharath SM <bharathsm.hsk@gmail.com>, linux-cifs@vger.kernel.org, sfrench@samba.org, 
	pc@manguebit.com, sprasad@microsoft.com, tom@talpey.com, 
	ronniesahlberg@gmail.com, Bharath SM <bharathsm@microsoft.com>
Content-Type: multipart/mixed; boundary="0000000000006e4d7b0629eb8fdd"

--0000000000006e4d7b0629eb8fdd
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thanks Shyam and Paul Aurich for reviewing and sharing comments.!
I have attached an updated patch.

On Fri, Dec 20, 2024 at 4:17=E2=80=AFAM Paul Aurich <paul@darkrain42.org> w=
rote:
>
> On 2024-12-19 15:03:48 +0530, Shyam Prasad N wrote:
> >On Tue, Dec 17, 2024 at 2:22=E2=80=AFAM Steve French <smfrench@gmail.com=
> wrote:
> >>
> >> merged into cifs-2.6.git for-next pending review and more testing
> >>
> >> On Mon, Dec 16, 2024 at 12:36=E2=80=AFPM Bharath SM <bharathsm.hsk@gma=
il.com> wrote:
> >> >
> >> > Previously, deferred file handles were reused only for read
> >> > operations, this commit extends to reusing deferred handles
> >> > for write operations.
> >> >
> >> > Signed-off-by: Bharath SM <bharathsm@microsoft.com>
> >> > ---
> >> >  fs/smb/client/file.c | 6 +++++-
> >> >  1 file changed, 5 insertions(+), 1 deletion(-)
> >> >
> >> > diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
> >> > index a58a3333ecc3..98deff1de74c 100644
> >> > --- a/fs/smb/client/file.c
> >> > +++ b/fs/smb/client/file.c
> >> > @@ -990,7 +990,11 @@ int cifs_open(struct inode *inode, struct file =
*file)
> >> >         }
> >> >
> >> >         /* Get the cached handle as SMB2 close is deferred */
> >> > -       rc =3D cifs_get_readable_path(tcon, full_path, &cfile);
> >> > +       if (OPEN_FMODE(file->f_flags) & FMODE_WRITE) {
> >> > +               rc =3D cifs_get_writable_path(tcon, full_path, FIND_=
WR_ANY, &cfile);
> >
> >Wondering if FIND_WR_ANY is okay for all use cases?
> >Specifically, I'm checking where FIND_WR_FSUID_ONLY is relevant.
> >@Steve French Is this for multiuser mounts? I don't think so, since
> >multiuser mounts come with their own tcon, and we search writable
> >files in our tcon's open list.
>
> I think this should be FIND_WR_FSUID_ONLY, yeah.  (IMHO, that should be t=
he
> default, and FIND_WR_ANY should be renamed something indicating it should=
 only
> be used in specific situations and it's probably not what the caller want=
s.)
>
> I have a series I need to resurrect and polish that fixes a few problems =
along
> these lines, but it doesn't touch the 'writable file' path.
>
> >> > +       } else {
> >> > +               rc =3D cifs_get_readable_path(tcon, full_path, &cfil=
e);
> >> > +       }
> >> >         if (rc =3D=3D 0) {
> >> >                 if (file->f_flags =3D=3D cfile->f_flags) {
> >> >                         file->private_data =3D cfile;
> >> > --
> >> > 2.43.0
> >> >
> >> >
> >>
> >>
> >> --
> >> Thanks,
> >>
> >> Steve
> >>
> >Other than that one thing to look at, the changes look good to me.
> >
> >--
> >Regards,
> >Shyam
>
> ~Paul
>

--0000000000006e4d7b0629eb8fdd
Content-Type: application/octet-stream; 
	name="0001-smb-enable-reuse-of-deferred-file-handles-for-write-.patch"
Content-Disposition: attachment; 
	filename="0001-smb-enable-reuse-of-deferred-file-handles-for-write-.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_m50r2ti50>
X-Attachment-Id: f_m50r2ti50

RnJvbSA4NjQzYWY3Nzg1N2UzMTI5OTI0ZTc4OGI0ZGVmOTg3Mjc5OGMxNzcyIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBCaGFyYXRoIFNNIDxiaGFyYXRoc21AbWljcm9zb2Z0LmNvbT4K
RGF0ZTogRnJpLCAxMyBEZWMgMjAyNCAyMjo1MDoyMSArMDUzMApTdWJqZWN0OiBbUEFUQ0hdIHNt
YjogZW5hYmxlIHJldXNlIG9mIGRlZmVycmVkIGZpbGUgaGFuZGxlcyBmb3Igd3JpdGUKIG9wZXJh
dGlvbnMKClByZXZpb3VzbHksIGRlZmVycmVkIGZpbGUgaGFuZGxlcyB3ZXJlIHJldXNlZCBvbmx5
IGZvciByZWFkCm9wZXJhdGlvbnMsIHRoaXMgY29tbWl0IGV4dGVuZHMgdG8gcmV1c2luZyBkZWZl
cnJlZCBoYW5kbGVzCmZvciB3cml0ZSBvcGVyYXRpb25zLiBCeSByZXVzaW5nIHRoZXNlIGhhbmRs
ZXMgd2UgY2FuIHJlZHVjZQp0aGUgbmVlZCBmb3Igb3Blbi9jbG9zZSBvcGVyYXRpb25zIG92ZXIg
dGhlIHdpcmUuCgpTaWduZWQtb2ZmLWJ5OiBCaGFyYXRoIFNNIDxiaGFyYXRoc21AbWljcm9zb2Z0
LmNvbT4KLS0tCiBmcy9zbWIvY2xpZW50L2ZpbGUuYyB8IDYgKysrKystCiAxIGZpbGUgY2hhbmdl
ZCwgNSBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pCgpkaWZmIC0tZ2l0IGEvZnMvc21iL2Ns
aWVudC9maWxlLmMgYi9mcy9zbWIvY2xpZW50L2ZpbGUuYwppbmRleCBhNThhMzMzM2VjYzMuLjNi
MmQzMzI5MWE3ZSAxMDA2NDQKLS0tIGEvZnMvc21iL2NsaWVudC9maWxlLmMKKysrIGIvZnMvc21i
L2NsaWVudC9maWxlLmMKQEAgLTk5MCw3ICs5OTAsMTEgQEAgaW50IGNpZnNfb3BlbihzdHJ1Y3Qg
aW5vZGUgKmlub2RlLCBzdHJ1Y3QgZmlsZSAqZmlsZSkKIAl9CiAKIAkvKiBHZXQgdGhlIGNhY2hl
ZCBoYW5kbGUgYXMgU01CMiBjbG9zZSBpcyBkZWZlcnJlZCAqLwotCXJjID0gY2lmc19nZXRfcmVh
ZGFibGVfcGF0aCh0Y29uLCBmdWxsX3BhdGgsICZjZmlsZSk7CisJaWYgKE9QRU5fRk1PREUoZmls
ZS0+Zl9mbGFncykgJiBGTU9ERV9XUklURSkgeworCQlyYyA9IGNpZnNfZ2V0X3dyaXRhYmxlX3Bh
dGgodGNvbiwgZnVsbF9wYXRoLCBGSU5EX1dSX0ZTVUlEX09OTFksICZjZmlsZSk7CisJfSBlbHNl
IHsKKwkJcmMgPSBjaWZzX2dldF9yZWFkYWJsZV9wYXRoKHRjb24sIGZ1bGxfcGF0aCwgJmNmaWxl
KTsKKwl9CiAJaWYgKHJjID09IDApIHsKIAkJaWYgKGZpbGUtPmZfZmxhZ3MgPT0gY2ZpbGUtPmZf
ZmxhZ3MpIHsKIAkJCWZpbGUtPnByaXZhdGVfZGF0YSA9IGNmaWxlOwotLSAKMi40My4wCgo=
--0000000000006e4d7b0629eb8fdd--
