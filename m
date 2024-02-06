Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1D0083CA1
	for <linux-cifs@vger.kernel.org>; Tue,  6 Feb 2024 06:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707200432; cv=none; b=ME28XJFQPbGDgooS1zemJRLlVdcuDpqIMHM1uVfDhbSYg0fO0ES3DNZIYFLSR7hJF+EU3O49DXfV1OnucyUCGJSodq/Zm0lwUeusDAMzZF3kl/4iFEFsb/51McneAqh4eGkJG4cDEEWApKX/vZQfec7kmvwa15B3UyY2D2/Venk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707200432; c=relaxed/simple;
	bh=ReCp4sgmL5SJ02/JaoXPw6mab3sKCa9odhCqMwKrNE0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=usEEl7aGPqfjl4lMBCFlFJRQ2Xp/mImAJly6aBWxQ0HZOXN8NvpLhKU884YaodVLd7n1uQJ8wAdPodSJbRsmgws7SH3A5pJZ21RFkwSe/UQY1Hy3MWF18hNF+A+7w2Wy4BnlBt2ifUREnJi4FfLBQKHyekTf0KDFvWA3Nipy+zU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VJh2dU/+; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VJh2dU/+"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-290d59df3f0so4275332a91.2
        for <linux-cifs@vger.kernel.org>; Mon, 05 Feb 2024 22:20:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707200430; x=1707805230; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JbWgYY2uQ6d1qovYv9Lh8MRY+9F4l+2JGmUdykkJWGw=;
        b=VJh2dU/+BmWjfRgkVdXpk/FYdBISljMBmTY2MpID54Xg3buf3Fx8lCS26u2yHxfwQm
         63iTVd9MsOACAMbcUE40bkMXPLVwM3IfJwDk0WnYnlu4A5XWFMF1IfhtB0npFS5fBOJz
         CUrWN+Xf21mNn3sTXhIcGPgtKbpiT1C45gfuH3giCe32VGh6hAQ6x120ywPZT/xN0FhW
         0mGEOVHzVQw8eLXpOSwFN1s4+vTh/EtmG1xjvxvcItZAqFoiOHgCVdEbQx4Qnd+l05aB
         8TL+hmv6M3r4sDKoRSUF1o/coNXkQSKx7ysJhemzvYkrzK1zk9PnZfhFPfTzuypsivUr
         HKNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707200430; x=1707805230;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JbWgYY2uQ6d1qovYv9Lh8MRY+9F4l+2JGmUdykkJWGw=;
        b=gR/xE2UXIT+B0MPDqbiLDOcb/gKSMq8II136wfGqhbHgg5WMuKX5XuTU/K2S83uZmC
         Ph3GiSvKR7lZPcrEHmqJAfWlT8S1XWljSwKUxvGSVM19MzbY3Fh7T1eHGfJBxXdEiri6
         ynDRkKK9YDlx2s/GmlluwJM1h+YxUYZ2655CxjMpebw2mNdFMbim+kF0sEaj0WFgn833
         gjXzHWvkOZrkyeq7P8HbVtzrFlYQ4j3uaO9oi3g9/PVtB79dAu/5sVlqoJmgtacHGNuO
         lAqgqDinuIMyQilQkEyPjy+OyBJHJb8Z9fU6kbl+t93dLec+Rgf6yj6vtnR96uqXbG6+
         ZnFA==
X-Gm-Message-State: AOJu0YzaM6gfmJM3el2DnWpKVwRu4ejCfWHlo3D1nWmKe3xZauNlhUPa
	CyXNT5lQdb0imwgld3HRhfU8gNx78GBxxE0fQWORpUtT0FJ0F/VUN/scMku1VyYHL1i5DVNuvXP
	oBGqaNWy4XBhlaffXoG2tI7PErYA=
X-Google-Smtp-Source: AGHT+IFrXiMcnCpeOgTtQ6bazYH6TkCwptsmDtFFrQl0y35r0VsyizHSGhC4DX0glz4uTrTEjOS9cJnidIpP9Eg58xU=
X-Received: by 2002:a17:90a:b38c:b0:296:2589:c05e with SMTP id
 e12-20020a17090ab38c00b002962589c05emr1606702pjr.30.1707200429949; Mon, 05
 Feb 2024 22:20:29 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <3003956.1707125148@warthog.procyon.org.uk> <CAH2r5mtYF4MgTz8v3DGfYiDycMMaGywuyPxF9-61d4575-S0bw@mail.gmail.com>
 <a356847f-afa0-446a-b896-fd2b9af2e393@rd10.de> <3004197.1707125484@warthog.procyon.org.uk>
 <262547e6-72e1-436f-8683-86f7a861f219@rd10.de> <CAH2r5mt3we_rcKrkyweaVcH53QVYE8jaV9NCvaEvOrt16bwr1w@mail.gmail.com>
 <CAH2r5mv6mvtSD3VpHKUtA_3zNDMGhFFkeLus1h5HpNZEJ2Q1pw@mail.gmail.com> <CAH2r5muy0UEnG1KmSgz1P_y9hP+-nj8wvZK5aGTGp6WW3F4mSA@mail.gmail.com>
In-Reply-To: <CAH2r5muy0UEnG1KmSgz1P_y9hP+-nj8wvZK5aGTGp6WW3F4mSA@mail.gmail.com>
From: ronnie sahlberg <ronniesahlberg@gmail.com>
Date: Tue, 6 Feb 2024 16:20:18 +1000
Message-ID: <CAN05THS4HuTfCHEpKG8D3mzo7omoz9mZFVuZGVTH_C2gqhKSHQ@mail.gmail.com>
Subject: Re: SMB 1.0 broken between Kernel versions 6.2 and 6.5
To: Steve French <smfrench@gmail.com>
Cc: "R. Diez" <rdiez-2006@rd10.de>, David Howells <dhowells@redhat.com>, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 6 Feb 2024 at 15:52, Steve French <smfrench@gmail.com> wrote:
>
> Digging deeper into this it looks like the problem is not the size
> being bigger than 32K but picking a write size (wsize) that is not a
> multiple of page size (4096).  I was able to reproduce this e.g. with
> wsize=3D70000 but not with 69632 (ie a multiple of page size, 17*4096)

Probably the easiest/quickest fix is to enforce rsize/wsize MUST be a
multiple of page-size ?
Is there any reason to support other sizes?
In the mount api you could just round these sizes up to the nearest
page size multiple.

>
> On Mon, Feb 5, 2024 at 10:05=E2=80=AFPM Steve French <smfrench@gmail.com>=
 wrote:
> >
> > In my additional experiments I could reproduce this but only with
> > wsize < 32768 but it wasn't SMB1 specific - I could reproduce it with
> > current dialects (smb3.1.1 e.g.) too not just SMB1 - so it is more
> > about you picking  small wsize that found the bug than an SMB1
> > specific problem.
> >
> > On Mon, Feb 5, 2024 at 7:30=E2=80=AFPM Steve French <smfrench@gmail.com=
> wrote:
> > >
> > > I can reproduce this now with a simple smb1 cp - but only with the sm=
all wsize
> > > ie mount option: wsize=3D16850.  As mentioned earlier the problem is
> > > that we see a 16K write, then the next write is at the wrong offset
> > > (leaving a hole)
> > >
> > > (it worked for SMB1 with default wsize)
> > >
> > > so focus is on these two functions in the call stack:
> > >
> > > [19085.611988]  cifs_async_writev+0x90/0x380 [cifs]
> > > [19085.612083]  cifs_writepages_region+0xadc/0xbb0 [cifs]
> > >
> > > On Mon, Feb 5, 2024 at 3:37=E2=80=AFAM R. Diez <rdiez-2006@rd10.de> w=
rote:
> > > >
> > > >
> > > > >> Unlikely as you didn't take them for the last merge window, let =
alone 6.2.
> > > > >
> > > > > That said, you did take my iteratorisation patches in 6.3 - but t=
hat shouldn't
> > > > > affect 6.2 unless someone backported them.
> > > >
> > > > Please note that 6.2 is not affected, the breakage occurred afterwa=
rds. See the bug report here for more information:
> > > >
> > > > https://bugs.launchpad.net/ubuntu/+source/linux/+bug/2049634
> > > >
> > > > Regards,
> > > >    rdiez
> > > >
> > >
> > >
> > > --
> > > Thanks,
> > >
> > > Steve
> >
> >
> >
> > --
> > Thanks,
> >
> > Steve
>
>
>
> --
> Thanks,
>
> Steve
>
