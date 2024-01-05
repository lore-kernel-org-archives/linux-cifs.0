Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CAE8241F4
	for <linux-cifs@vger.kernel.org>; Fri,  5 Jan 2024 09:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PFRcY3TM"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-50e7f58c5fbso1761717e87.1
        for <linux-cifs@vger.kernel.org>; Fri, 05 Jan 2024 01:39:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1704447582; x=1705052382; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EtgubL+nkia1lR8g6fJs8/LX7BG4L9GjDmSywRwFk30=;
        b=PFRcY3TM7kurHhnFMjG000FFIILCe5Nqk+J+PXhdQ5MFA0Mju28XJBtXJupgw6pYfk
         WD6zHyxoF0mLpMHNmT/oL1bxsHnoI15f5VY7VioAETvmWOhpNjBzK5i3C3N0S+6B7Wzi
         PnKM4O/CK9SwMzyVUu6ejxnfhnIDSeOX+Ivzmk7CfpfS/tMp8iNsUjXKjCKNeorJKn9n
         N+4rDYv5jlRf+V07keXy6w+ySSsGsj9PoUOj7Cqt5azESVVJ8PPzxZTZBFjy8ZvIVSRL
         6WbdBjNehJ3exg+Ce3Sq3J4paDguCWoF9ZpaSXmRJJS/BTjjeXQzXF7ZOwoxRgIURcEh
         QFGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704447582; x=1705052382;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EtgubL+nkia1lR8g6fJs8/LX7BG4L9GjDmSywRwFk30=;
        b=P8Z52y7nOSVVULyECKQGmR5S7c3HJs9Ez6hHQ9oWoKa7RsrtgvhnLjnif61a9E2o8b
         g9ROjM+L99fEQr4aKNi5IB9E8OXeNjF3pCUxQu3lEjRi7hTXPCuaTPdwaFdXq4BOImQ+
         7DKluoNOgdMut86sGNW76IlpfN4vDIf/Q46UTDFt+SqKOK+LZ82sEhdJNxBIosD4Mh8B
         3h+HRRt1jqGToKICf1GRWic8GagvzgpUZfPVSDhCWQlzBrz/1nLkhQFv4yIpub+3eCQm
         rIscBFsIS/CuZ2uTf9CN9mV4ajDqHPgO+SG43RaRkqwV7yL/djEW7XxeVxXQW/ceZ76Q
         AkRw==
X-Gm-Message-State: AOJu0YwxQyUAPD7cXvzTwWNjh3z4lF11eNA5AI/8WUl4ZH7TvUsDQjta
	Ec2t8dZ7boTJ6lgTaUCuWzq7XGungqRqSaRIzEE=
X-Google-Smtp-Source: AGHT+IED9zOdJgUWQdfxcNjRdLLVogtU2gybLYPjMlI+RTgTb6S+8CymkI1+Q0N+g3nmCIJ3JrTHP9hGa62wZVxNdp8=
X-Received: by 2002:a19:f01a:0:b0:50e:554a:5254 with SMTP id
 p26-20020a19f01a000000b0050e554a5254mr972080lfc.13.1704447581868; Fri, 05 Jan
 2024 01:39:41 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231229143521.44880-1-meetakshisetiyaoss@gmail.com>
 <20231229143521.44880-2-meetakshisetiyaoss@gmail.com> <7e61ce96ef41bdaf26ac765eda224381@manguebit.com>
 <CAFTVevWC-6S-fbDupfUugEOh_gP-1xrNuZpD15Of9zW5G9BuDQ@mail.gmail.com>
 <c618ab330758fcba46f4a0a6e4158414@manguebit.com> <62eb08fb-b27f-4c95-ab29-ac838f24d70f@talpey.com>
In-Reply-To: <62eb08fb-b27f-4c95-ab29-ac838f24d70f@talpey.com>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Fri, 5 Jan 2024 15:09:30 +0530
Message-ID: <CANT5p=qqUbqbedW+ccdSQz2q1N-NNA-kqw4y8xSrfdOdbjAyjg@mail.gmail.com>
Subject: Re: [PATCH 2/2] smb: client: retry compound request without reusing lease
To: Tom Talpey <tom@talpey.com>
Cc: Paulo Alcantara <pc@manguebit.com>, Meetakshi Setiya <meetakshisetiyaoss@gmail.com>, sfrench@samba.org, 
	sprasad@microsoft.com, linux-cifs@vger.kernel.org, bharathsm.hsk@gmail.com, 
	samba-technical@lists.samba.org, Meetakshi Setiya <msetiya@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 5, 2024 at 2:39=E2=80=AFAM Tom Talpey <tom@talpey.com> wrote:
>
> On 1/3/2024 9:37 AM, Paulo Alcantara wrote:
> > Meetakshi Setiya <meetakshisetiyaoss@gmail.com> writes:
> >
> >> As per the discussion with Tom on the previous version of the changes,=
 I
> >> conferred with Shyam and Steve about possible workarounds and this see=
med like a
> >> choice which did the job without much perf drawbacks and code changes.=
 One
> >> highlighted difference between the two could be that in the previous
> >> version, lease
> >> would not be reused for any file with hardlinks at all, even though th=
e inode
> >> may hold the correct lease for that particular file. The current chang=
es
> >> would take care of this by sending the lease at least once, irrespecti=
ve of the
> >> number of hardlinks.
> >
> > Thanks for the explanation.  However, the code change size is no excuse
> > for providing workarounds rather than the actual fix.
>
> I have to agree. And it really isn't much of a workaround either.
>

The original problem, i.e. compound operations like
unlink/rename/setsize not sending a lease key is very prevalent on the
field.
Unfortunately, fixing that exposed this problem with hard links.
So Steve suggested getting this fix to a shape where it's fixing the
original problem, even if it means that it does not fix it for the
case of where there are open handles to multiple hard links to the
same file.
Only thing we need to be careful of is that it does not make things
worse for other workloads.

> > A possible way to handle such case would be keeping a list of
> > pathname:lease_key pairs inside the inode, so in smb2_compound_op() you
> > could look up the lease key by using @dentry.  I'm not sure if there's =
a
> > better way to handle it as I haven't looked into it further.
>

This seems like a reasonable change to make. That will make sure that
we stick to what the protocol recommends.
I'm not sure that this change will be a simple one. There could be
several places where we make an assumption that the lease is
associated with an inode, and not a link.

And I'm not yet fully convinced that the spec itself is doing the
right thing by tying the lease with the link, rather than the file.
Shouldn't the lease protect the data of the file, and not the link
itself? If opening two links to the same file with two different lease
keys end up breaking each other's leases, what's the point?

> A list would also allow for better handling of lease revocation.
> It seems to me this approach basically discards the original lease,
> putting the client's cached data at risk, no? And what happens if
> EINVAL comes back again, or the connection breaks? Is this a
> recoverable situation?
>
> Also, what's up with the xfstest the robot mailed about?
Meetakshi is investigating this one.
Initial investigations led us to believe that this is related to
deferred closes. The failing tests do show that the close is getting
delayed, and that setting closetimeo=3D0 causes the test to pass.
However, it is not clear why the test started failing only now. We'll
have the answers soon.

>
> Tom.



--=20
Regards,
Shyam
