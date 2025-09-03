Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28CC32DE6FB
	for <linux-cifs@vger.kernel.org>; Wed,  3 Sep 2025 20:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756932289; cv=none; b=Ni3Z21sikphf5Kv3/79nfc4Ax7pN0Io0lusKarnUp0IztTtz0Gc8z17QDKvZB5r8vhtLhaKLZEqo4MhUHtShymr7MD0qmS8154zQl/U9/iaUsfRWgx/az6GFFQ99W6CtLRAtcmCZmw2VvZHMpLLPewD967+GqFUMK7CnUZmQA/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756932289; c=relaxed/simple;
	bh=bnZK2iE1t8HmElndKVws08ERSJxt/6MRSPKW96FS8/M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=a04N6x6CeZ+u63ATNm6QkRqf8kr5SUwjbglkSbrpy7Yks3Q+2AdBisLhuJX/e5mYSWs54ZEyzjDcX+tIXgApoWKPy8s8prVvZdFBRX2w1vUEkKUF5ObpH+yf9/5sVjR5TiOJNPWi6lrbUJt7dBXzhZJT11tEru512MhvvcKKRPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KaZjXAf0; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KaZjXAf0"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-329a41dc2ebso179912a91.3
        for <linux-cifs@vger.kernel.org>; Wed, 03 Sep 2025 13:44:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756932287; x=1757537087; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=IxSZKM6vmKnaN2Ns2g/VzmaYMhvbtva9z5uCjwHQWgE=;
        b=KaZjXAf0JXX9j8kyB6N/6quhiL7p6QDPq9pjahZxXZT0kELFev+rcH4XtQX8XUZX24
         A2/9Kqalgws+4lxCCjGSzOd/IUS7Oiy7Cuvslcn8y3m8dFFJ+0oYH5NIm/2GRNrHRQ+W
         Tw/UIKATaicslNd5Pxxi+tRbgsSNisSuW2c80qHZms1Fx6lwGQ9X68kTeIpDj7f8wVDQ
         tSYt2PB/OmTjUKdliWnXmvmJP3OcLKiRemaj+EXTGknuNRu2DCe9CPLGKQdjwsr5V0X5
         +2I6rozBxu8XMMXUXwy1odpcVGdxyug8Gz7nneSQdGvr/VLFW9TzHqRMZvoVnp2/jVoD
         i8HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756932287; x=1757537087;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IxSZKM6vmKnaN2Ns2g/VzmaYMhvbtva9z5uCjwHQWgE=;
        b=P08AFuGLk2bNU7tl+whXMw5hGPMzDCyWx4dEU1COK1YwR2mHwgym07X269yiIoZjnC
         fi1W7xAAixVgEcKFfv34YgCfnK+6XFs35VRZortcB9Ycd+95nkgNdeYPkhIJqR0EbcPt
         AJ2glDQ5yj6uhu91+H0QqbcuhPiK4zS3VDG5IO7dG/mDXdf/U0CeKhoAIXxJWhjBxlDx
         STQ0EOwlirC4h3quucuzZ+Ufy/7F1A371ifuTqC/9X7fMyoWatbDB32SAMJ2l5RaXzH7
         Rg1B/ASCsu/kzigxgkTWq8luNVyHTC/iqqSJhzbWwkHeh+pydDZk1hfMlMN2XQb2Yqa8
         tF3Q==
X-Forwarded-Encrypted: i=1; AJvYcCWqlbBAEFaRnBLcfcUF7JXFfYr2ePoW0LM74TgydhCWNPcRJ0IjR4kHXS9HN1f7hOvnsQRwd1sBB2BZ@vger.kernel.org
X-Gm-Message-State: AOJu0Yyup3paLAR8s6MEtZhgZBvQh2ylppoqGCOZJFj3PLuRpTKxY9hi
	T06Zll+Ea+Pein1kfpzJMlXZtV2ToRDsPOdy7yFP+e35iiLb5Q74oL6QbSkOYWdcgbxufCWg5Tt
	hiijnpXJj+etfD6oHO9AM/c4RH1dN2LM=
X-Gm-Gg: ASbGncuf/6phGgiRqiWuGibPzVkkBX94hvXOHZ9Lvbac4Oa1xVnRlIvj8NTSS2jm8j0
	QYPRxWUJFUT7ylDjICkFPWEEUGqh68CesoPEZwhmakeENZ14AOMOhimCWDP4iFgVOyrcBlNsxDP
	rz3BfxRa9V/xmXbrQtRewRy1U9mvBIGmdh7DdsN/kLuCRe2V1SxQydnpQ/KsIvc48jjQ6ASh3OP
	ko3P+KJufZ2/7OeyfJCS1QyTO2oUa5obqEa17m+HefNe3BacFodtXPHzpX6NvDakuwd
X-Google-Smtp-Source: AGHT+IFwlsWcedhWTFnPgsqiaDd/zvi5yre9jb4gRLANikKcs3FLNTGMSttqYwEJWMzZkSg1f8NrhHWcruUYRDfhYbQ=
X-Received: by 2002:a17:90b:5587:b0:32b:4c71:f40a with SMTP id
 98e67ed59e1d1-32b4c71f85amr8015803a91.24.1756932287434; Wed, 03 Sep 2025
 13:44:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250902165451.892165-1-pc@manguebit.org> <cd16cf45-efc8-4324-9d40-0b92f15f179a@samba.org>
 <da2380aa8e3718066bfc151bf60e54ea@manguebit.org> <d3702a1b-0dfc-4d56-8f0c-0cd588f151b2@samba.org>
 <faf6c4eaa69a36617d65327b98ed105d@manguebit.org> <CAN05THSWdDsuqBTkdL5H2tjBwNgPeO4k6fYFEqkYS_P3oc0t8Q@mail.gmail.com>
 <CAN05THSmQ-75m4dVDBiXoLLNcXnMCJbnCVCK-=ev0F98eDDwxg@mail.gmail.com> <28081fd56fa72705de6616f5c29f3695@manguebit.org>
In-Reply-To: <28081fd56fa72705de6616f5c29f3695@manguebit.org>
From: ronnie sahlberg <ronniesahlberg@gmail.com>
Date: Thu, 4 Sep 2025 06:44:35 +1000
X-Gm-Features: Ac12FXyuAng7z52wSsX4-VQTeiQN1QUqIOavbT_0nFn1Ia49htB4PBnIMyn8Z5g
Message-ID: <CAN05THQ0hGERkn+KVjbX_1z0AzZ4EeSBfjiQ_Ap=1+Ni4FGkQA@mail.gmail.com>
Subject: Re: [PATCH v2] smb: client: fix data loss due to broken rename(2)
To: Paulo Alcantara <pc@manguebit.org>
Cc: Ralph Boehme <slow@samba.org>, smfrench@gmail.com, 
	Jean-Baptiste Denis <jbdenis@pasteur.fr>, Frank Sorenson <sorenson@redhat.com>, 
	Olga Kornievskaia <okorniev@redhat.com>, Benjamin Coddington <bcodding@redhat.com>, 
	Scott Mayhew <smayhew@redhat.com>, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 4 Sept 2025 at 06:28, Paulo Alcantara <pc@manguebit.org> wrote:
>
> ronnie sahlberg <ronniesahlberg@gmail.com> writes:
>
> > On Thu, 4 Sept 2025 at 05:55, ronnie sahlberg <ronniesahlberg@gmail.com> wrote:
> >>
> >> On Thu, 4 Sept 2025 at 04:46, Paulo Alcantara <pc@manguebit.org> wrote:
> >> >
> >> > Ralph Boehme <slow@samba.org> writes:
> >> >
> >> > > Hi Paulo,
> >> > >
> >> > > On 9/2/25 9:09 PM, Paulo Alcantara wrote:
> >> > >> Ralph Boehme <slow@samba.org> writes:
> >> > >>
> >> > >>> Why not simply fail the rename instead of trying to implement some
> >> > >>> clever but complex and error prone fallback?
> >> > >>
> >> > >> We're doing this for SMB1 for a very long time and haven't heard of any
> >> > >> issues so far.  I've got a "safer" version [1] that does everything a
> >> > >> single compound request but then implemented this non-compound version
> >> > >> due to an existing Azure bug that seems to limit the compound in 4
> >> > >> commands, AFAICT.  Most applications depend on such behavior working,
> >> > >> which is renaming open files.
> >> > >
> >> > > maybe I'm barking of the wrong tree, but you *can* rename open files:
> >> > >
> >> > > $ bin/smbclient -U 'USER%PASS' //IP/C\$
> >> > > smb: \> cd Users\administrator.WINCLUSTER\Desktop\
> >> > > smb: \Users\administrator.WINCLUSTER\Desktop\> open
> >> > > t-ph-oplock-b-downgraded-s.cab
> >> > > open file
> >> > > \Users\administrator.WINCLUSTER\Desktop\t-ph-oplock-b-downgraded-s.cab:
> >> > > for read/write fnum 1
> >> > > smb: \Users\administrator.WINCLUSTER\Desktop\> rename
> >> > > t-ph-oplock-b-downgraded-s.cab renamed
> >> > > smb: \Users\administrator.WINCLUSTER\Desktop\>
> >> > >
> >> > > ...given the open is with SHARE_DELETE (had to tweak smbclient to
> >> > > actually allow that).
> >> >
> >> > Interesting.
> >> >
> >> > cifs.ko will get STATUS_ACCESS_DENIED when attempting to rename the open
> >> > file.  The file was open with SHARE_READ|SHARE_WRITE|SHARE_DELETE, BTW.
> >> >
> >> > Also, note that cifs.ko will not reuse the open handle, rather it will
> >> > send a compound request of create+set_info(rename)+close to the file
> >> > which will fail with STATUS_ACCESS_DENIED.
> >> >
> >> > What am I missing?
> >> >
> >> > > If the rename destination is open and the server rightly fails the
> >> > > rename for that reason, then masking that error is a mistake imho.
> >> > >
> >> > > When doing
> >> > >
> >> > > $ mv a b
> >> > >
> >> > > the user asked to rename a, he did NOT ask to rename b which becomes
> >> > > important, because if you do
> >> > >
> >> > > rename("b", ".renamehackXXXX")
> >> > >
> >> > > under the hood and then reattempt the rename
> >> > >
> >> > > rename("a", "b")
> >> > >
> >> > > and then the user subsequently does
> >> > >
> >> > > $ mv b ..
> >> > > $ cd ..
> >> > > $ rmdir DIR
> >> > >
> >> > > where DIR is the directory all of the above was performed inside, the
> >> > > rmdir will fail with ENOTEMPTY and *now* the user is confused.
> >> >
> >> > Yes, I understand your point.  That's really confusing.
> >> >
> >> > How can we resolve above cases without performing the silly renames
> >> > then?
> >> >
> >>
> >> I think you can't.  CIFS, without the posix extensions, is basically
> >> not posix and never will be.
> >> You can make it close but it will never be perfect and you will have
> >> to decide on how/what posix semantics you need to give up.
> >>
> >> What compounds the issue is that cifs on linux (without the posix
> >> extensions) will also always be a second class citizen.
> >> Genuine windows clients own this protocol and they expect their own
> >> non-posix semantics for their vfs, so you can't do anything that
> >> impacts windows clients, they are the first class citizen here.
> >>
> >> The two main issues I see with the silly renames are the "-ENOTEMPTY"
> >> error when trying to delete the "empty" directory, but also
> >> that you can not hide them from windows clients. And what happens if
> >> the windows clients start accessing them?
> >>
> >> I think the only real solution is to say "if you need posix semantics
> >> then you need to use the posix extensions".
> >
> > Another potential issue is about QUERY_INFO.
> > Many of the information classes in FSCC return the filename as as part
> > of the data.
> > What filename should be returned for a silly renamed file?
> >
> > Maybe it doesn't matter  but maybe there is some obscure windows
> > application out there that do care and gets surprised.
>
> I don't think that matters as file deletion is pending on the server and
> QUERY_INFO won't work.
>
> What am I missing?

You missed nothing. I didn't think it through.

But another potential issue is the possibility of a DOS from malicious
windows clients.
If the files are "hidden" from linux clients.
How would a linux client recover if a maliciious windows client just
creates an ordinary file with a filename that matches the "silly
rename prefix".
The file can not be seen or deleted from linux clients and thus the
directory becomes undeletable too?
