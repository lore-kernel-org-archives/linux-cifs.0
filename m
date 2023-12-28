Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 400FAF508
	for <linux-cifs@vger.kernel.org>; Thu, 28 Dec 2023 16:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SrKt/q5V"
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-2cc3f5e7451so66836201fa.2
        for <linux-cifs@vger.kernel.org>; Thu, 28 Dec 2023 08:56:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1703782607; x=1704387407; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iTVntB/GPrHXw2R6zJAIPyFWP7zsGfOJ734eki+KlKs=;
        b=SrKt/q5V/PsBeDywzpZ6YGha4NrV/ARY3jj9qzt7Yx7595QYymD7AK+9CMi7JLbZhd
         4Oz2WhO2SzIVdb1bMoZS7hvFprOn8+M4otcwA4bDkX0Ok0UTLVlQ2sP4u/OB9kdq6uQh
         KRAwl/i6vqoYSzHhtrOIsMgnNHIUvapbmHpgsDOs5Bw33pUH9RC7uYvffUUW8/lmkJLg
         8btkmZg3Nt8UBGzDfhJfGAGxFmBwnJUM0jj0CKyUfHHHL/9DfhwukeT1D0r2AsSSVsza
         h75leqoctBFhO1kpkEdeuwNJrdNk2Aav6hNxRUBV/oxCR2Xdh3W9TkeLZlb13Mg1noOs
         lWYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703782607; x=1704387407;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iTVntB/GPrHXw2R6zJAIPyFWP7zsGfOJ734eki+KlKs=;
        b=lxYQZhFkghZuHssfhc/yQ5J+BIDk8fvLMvuI4LFZvsylYEsAjIShD3b/SWVvBRTM86
         tOninTA8lSJKkrDceFHt/OHsAY7jcdUspgT3P2qorTLClC/WAnIFgvLTdsoRzPy2mvur
         Hu0XJe/TEvmQ+LiwCEHaYPNw/2vFIOPspilI0VvJmxHr9Rk8oTp39Dm+KSYVKuTez8p4
         gmDe/Vg3lBkh6GQ+octFJEEyYBeNZ55ubrpcp1zSigG2mpjurREs7TxT/GbZWPqa8K6m
         WXyVMb/0+4ZXtHj7jjKoze7rUcXc/e1nJM36Do1jVb49jILw31+QCBtuov/Ia5AogH56
         hziQ==
X-Gm-Message-State: AOJu0YzXgNdTWCW0wVKQ8NqgkDznorTGBzuiRUMzsLBZxS+C1iYRR9B0
	VaNI5MN5cQs1Y2FMK6+np0KdlTbwcB3tPddPD6o=
X-Google-Smtp-Source: AGHT+IHN8JrTrbs0+nye+m2UyNS0fvaspa+uQqf3J6nJCLY9WvEqnRpEOid9ZovHpc33OaZDkoveRpYOG8N/SLPx+is=
X-Received: by 2002:a2e:8058:0:b0:2cc:a253:a4a6 with SMTP id
 p24-20020a2e8058000000b002cca253a4a6mr4415677ljg.50.1703782606849; Thu, 28
 Dec 2023 08:56:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CANXojczLxkjk86KFjobCkpt=VuUWsTJTs82=_XCwieGTiQcFAA@mail.gmail.com>
 <CAOQ4uxgxEAWrkrm8Ot9kGT4ZBD=mkOxYDxmBKnsS0rotQKCcZw@mail.gmail.com>
 <CANXojcy33kY=nsCQAYroE3jQU844AqK0E4=FPStowLO5RvZTFA@mail.gmail.com>
 <CAH2r5mszKHzGZDvqieMoDTtNJ1C61Z_XtEEvZE0KeCk4KhEPkg@mail.gmail.com>
 <CANXojcwfbyZnaV_MdhujEgLcB9zCdBSMpSvmtyRNSq5zfUzNDg@mail.gmail.com>
 <CANXojcz3SCf2wnVugsgk_3x9G_60Kj8sdKHzNNcREXT7xLkLRQ@mail.gmail.com>
 <CAOQ4uxhWpT8HaAdCBn+Ep4pT1Ewo=Mf7-sFczZf3oOcdrPZ0=w@mail.gmail.com>
 <CANXojcypbYr6a056KDZMTwNiU5XXOtxP9=1EWG4ioHT6sm2kQw@mail.gmail.com>
 <CAOQ4uxhK=Byka1kZ+cJfTzxboB7nf7qPRVe9q5HVRLepecR-xg@mail.gmail.com> <CANXojczjedUALTBnsajY_CMJW82SLOy=M_qU_jqcFzh30PoxBg@mail.gmail.com>
In-Reply-To: <CANXojczjedUALTBnsajY_CMJW82SLOy=M_qU_jqcFzh30PoxBg@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Thu, 28 Dec 2023 10:56:35 -0600
Message-ID: <CAH2r5mu7vAdfzZN9D_cQugYvhUJ+9A19R5nxtO=+fRAxKf7xJw@mail.gmail.com>
Subject: Re: Attention for fsnotify working with FUSE (and CIFS and NFS)
To: Stef Bon <stefbon@gmail.com>
Cc: Amir Goldstein <amir73il@gmail.com>, Ioannis Angelakopoulos <iangelak@redhat.com>, 
	fuse-devel <fuse-devel@lists.sourceforge.net>, 
	"sonny@fastmail.net" <sonny@fastmail.net>, David Howells <dhowells@redhat.com>, 
	"jack@suse.com" <jack@suse.com>, "jake@lwn.net" <jake@lwn.net>, CIFS <linux-cifs@vger.kernel.org>, 
	Paulo Alcantara <pc@manguebit.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 28, 2023 at 10:52=E2=80=AFAM Stef Bon <stefbon@gmail.com> wrote=
:
>
> Op do 28 dec 2023 om 15:46 schreef Amir Goldstein <amir73il@gmail.com>:
> >
> > On Wed, Dec 27, 2023 at 7:56=E2=80=AFPM Stef Bon <stefbon@gmail.com> wr=
ote:
> > >
> > > Op wo 27 dec 2023 om 15:00 schreef Amir Goldstein <amir73il@gmail.com=
>:
> > > >
> > > >
> > >
> > > > > backend may not wait for the sending (and possibly receiving the
> > > > > status reply) cause this may take too much time.
> > > >
> > > > Not sure why you think that it cannot wait.
> > > > I think that setting the remote mark should wait.
> > > >
> > >
> > > Well the send and recv can block due to various circumstances (networ=
k
> > > problems, bad written software, we want to support FUSE fs's right?).
> > > The system call to inotify might block cause of this and this is not
> > > what you want.
> > >
> >
> > I disagree.
> > A typical workflow is:
> > 1. setup watch
> > 2. wait for events
>
> Yes i know. You do not have to explain me the workflow. I don't think
> that the setting of a watch has to wait for the remote server has
> received the watch, set it, and send a reply. We're talking about a
> system call here (inotify_add_watch), and you don't mind it might
> block? Strange.
>
>
> > > This work of Ioannis Angelakopoulos is not implemented? What happened=
?
> > >
> >
> > He posted patches.
> > We provided feedback and raised some questions about the API.
> > Nobody followed up on that feedback with new patches
> > and not all open API questions have been resolved.
> >
>
> >
> > There is no mandate for you to implement ->fsnotify_upadate()
> > in cifs, if you are only interested in FUSE.
>
> There is lot of miscommunication between you and me. I never said I
> stick to FUSE and forget the rest. I said I start with implementing it
> with FUSE, cause I'm very familiar with that. It was my response to
> you saying I should start working on cifs. which I think is not for
> you to decide where to start.
>
> >
> > The mandate is to guarantee that the API you design for FUSE
> > *could* work also for cifs.
> > Since cifs really does implement remote notification, it would be
> > very recommended to show at least a POC of how the API can
> > work with cifs - I am sure that if you provide POC code, Steve
> > and cifs developers would be able to test it and provide feedback.

Yes - added Paulo and linux-cifs to cc

> See above. My intention is to start with FUSE and if that works, make
> it work for others as well. Not only cifs by the way, there are more
> fs's.

We should be able to get multiple people interested in fixing the
inotify/fsnotify
for cifs.ko mounts - it is a reasonably commonly requested function


> > > Why do you think that?
> > >
> >
> > Please follow the discussion on Ioannis patches regarding
> > local vs. remote notifications - it is a mess.
> > There was no consensus how local and remote notifications
> > could be reported together on the same group.
> >
>
> I will read that. For me there is no reason to keep them apart, but
> some rules have to be taken care of.
>
> >
> > I think you may  have a misconception of the relationship between
> > fsnotify/inotify/fanotify.
>
> Again, this is not the case. I know how it is designed, But inotify
> and fanotify differ very much, maybe they should be designed as two
> separate subsystems:
> - fanotify local only, focus on open/write/close access and deny.
> Provide an fd. Manage access.
> - inotify only about reporting events (any!), local and remote, only a
> name and a reference to a watch.



--=20
Thanks,

Steve
