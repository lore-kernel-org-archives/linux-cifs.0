Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFA722DAFDD
	for <linux-cifs@vger.kernel.org>; Wed,  3 Sep 2025 20:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756930223; cv=none; b=tRAxjfjtIEqnrMMEFPeZao/ae+NoepcvWJYHrvXy7wS5X02GLTqydYt9qkLbp0b/3yaoqy7uXZXQMMp1kJMq7/WBB7IP8/6vKgoVfTXc/lIsLpslKw4AK3WpTZf3O5pzyhrbM1W7fft0gqxQIpN6sh72/aipCWrCsrRxiHu+QCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756930223; c=relaxed/simple;
	bh=6yIfAKIMKleaqSS2l2EP5BK4adr4mf+xI7X1iDH/ELw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gDWqY2rRGAY63vMG3LsJAsChM6oZOLW315fDQkCIiRGrBixzADIv03R86OILF1Aee1NlMJKE7VwSJy2LKFdi3Hnchvhp2z9bd/+yfRS/i2wK/cnPX1n35wxkGLJd98cgFEKXPs1+ajkLwidQT3UnFINvyXOM0KnkbjUKP0SNJjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=T/KW54fv; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T/KW54fv"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2445826fd9dso3951635ad.3
        for <linux-cifs@vger.kernel.org>; Wed, 03 Sep 2025 13:10:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756930221; x=1757535021; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=pTkaT4VeGgrpqRr7zW9Vw+P8Jeih4RF8f12u4ji4/TQ=;
        b=T/KW54fvzAf4ZgVuXFW7OmkzI19pVeyGyYN17VeFCPq1CfwtWlLpHV1Dx4jZaySti/
         rh9rlAvj0XEi8J+Ze3qqpv/upAXx/ZE3lQnUG6OauRSRMBQ+lyZfIMZ0y8VqA99lWR63
         RQQnpgj+/dGlJKSXpZq3qZFkRhphDQv3kZbHSmNAz2NnfHp4USf3l7bg0KbgJuvmYBMf
         ckQ8JUQGlUVFV+0JzrhbtlqUsEVxFYhl3zb+91eWwEV1JfAnOfeFC7TTfKcums65h9aK
         1CcVRApLnNrPyEeMoerz7JHBlZWnbMoOrz1aLIYVq9OqShch/y7uW0piwXIW6LA3d47E
         F0UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756930221; x=1757535021;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pTkaT4VeGgrpqRr7zW9Vw+P8Jeih4RF8f12u4ji4/TQ=;
        b=YzFTWjX1sL0/bDZ8+Md3Chk8aTOXJk/JnIGyF+Ns9hld5lsVTmpCZmvnIXzeWGP/O0
         eD8iI1WmztrZX9H+MAlnhisyaeIe6xDSOa68zwPTH1MzQb+GYJ7Mwrg61irYW1JVJeNK
         8ovadbegWk8H2mRDEq4cWdCyvI8xWlSTagpsiU9eJMhcBjvlsy/i0dbM5TODKNndSJku
         Lp20gzoAMhWSU3mAZS78Un+uE1kXm1yhYj0VztlcROzKBCSaRVvQmZfjAiflpY7PCa8M
         TcUzeiMKNMlnGKaVEoNalcV8A0A7N14V50cHEJWZqY1xiA6yMQY7LorEV9Zd71yuOCRp
         NECA==
X-Forwarded-Encrypted: i=1; AJvYcCXpBuuWuCadGEfcPh4+64JfqCvjjCkgC3WzL9CBCNcE859LMwO6120fD5UUkJjXDdxfqGuwv8Dx1pBx@vger.kernel.org
X-Gm-Message-State: AOJu0YznoRokqXiwjhxPzWkIR8ynHgzeK/KFiQIs9DCGRTxwNY2gbZw+
	zGcEGRPsz1mvdWuE5HHZznPsAnzeLQvo7zCakYxUpiNgOzFRdYRp5SteRltucb/rdQAM1lVopg5
	J7+B48GilTdFAJ4Inu7k2AoXKZ+XQyO0=
X-Gm-Gg: ASbGncu+WYRb/cfZYMB91I8nLmt7XbpjVETQW1J6GSEmu/bC3ptdjprstRL4Vpkihio
	L6UcMAXSUQtul2B+OzLYMMzWQnIUUeCEopm5XT5zIw3QqJUJk6JACF3QhTn4IU5Q39kCM8IaQcS
	r/Uu2KQ9kpdukAuaFs7KqCaskoudGK2bZXnHLSxdGKgWWNbtKOEneEcpptePuB3/cMNOgycrPH9
	9Klj0DycvmJBSg9jbIJy9f+yCNclbQcpL803yaNchuz6PaPJNz19RwuopyulgzdcetMzoCGBZg/
	19M=
X-Google-Smtp-Source: AGHT+IFr6v6X/xKjHAxNfLxbFrEfJ5Tg1OsIN2M7moMSIxPIn16213Z5nAchZBE9FzrZ04Sjn44HFH4kBHDciyo3REY=
X-Received: by 2002:a17:903:32c6:b0:248:8626:8e38 with SMTP id
 d9443c01a7336-249448d72cfmr212420695ad.17.1756930220899; Wed, 03 Sep 2025
 13:10:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250902165451.892165-1-pc@manguebit.org> <cd16cf45-efc8-4324-9d40-0b92f15f179a@samba.org>
 <da2380aa8e3718066bfc151bf60e54ea@manguebit.org> <d3702a1b-0dfc-4d56-8f0c-0cd588f151b2@samba.org>
 <faf6c4eaa69a36617d65327b98ed105d@manguebit.org> <CAN05THSWdDsuqBTkdL5H2tjBwNgPeO4k6fYFEqkYS_P3oc0t8Q@mail.gmail.com>
In-Reply-To: <CAN05THSWdDsuqBTkdL5H2tjBwNgPeO4k6fYFEqkYS_P3oc0t8Q@mail.gmail.com>
From: ronnie sahlberg <ronniesahlberg@gmail.com>
Date: Thu, 4 Sep 2025 06:10:09 +1000
X-Gm-Features: Ac12FXzakXh-GWXftI7DYSUqGmCuEAkrkcyMg9yP5ZPwbLo-W58X3CNmm7oBrkY
Message-ID: <CAN05THSmQ-75m4dVDBiXoLLNcXnMCJbnCVCK-=ev0F98eDDwxg@mail.gmail.com>
Subject: Re: [PATCH v2] smb: client: fix data loss due to broken rename(2)
To: Paulo Alcantara <pc@manguebit.org>
Cc: Ralph Boehme <slow@samba.org>, smfrench@gmail.com, 
	Jean-Baptiste Denis <jbdenis@pasteur.fr>, Frank Sorenson <sorenson@redhat.com>, 
	Olga Kornievskaia <okorniev@redhat.com>, Benjamin Coddington <bcodding@redhat.com>, 
	Scott Mayhew <smayhew@redhat.com>, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 4 Sept 2025 at 05:55, ronnie sahlberg <ronniesahlberg@gmail.com> wrote:
>
> On Thu, 4 Sept 2025 at 04:46, Paulo Alcantara <pc@manguebit.org> wrote:
> >
> > Ralph Boehme <slow@samba.org> writes:
> >
> > > Hi Paulo,
> > >
> > > On 9/2/25 9:09 PM, Paulo Alcantara wrote:
> > >> Ralph Boehme <slow@samba.org> writes:
> > >>
> > >>> Why not simply fail the rename instead of trying to implement some
> > >>> clever but complex and error prone fallback?
> > >>
> > >> We're doing this for SMB1 for a very long time and haven't heard of any
> > >> issues so far.  I've got a "safer" version [1] that does everything a
> > >> single compound request but then implemented this non-compound version
> > >> due to an existing Azure bug that seems to limit the compound in 4
> > >> commands, AFAICT.  Most applications depend on such behavior working,
> > >> which is renaming open files.
> > >
> > > maybe I'm barking of the wrong tree, but you *can* rename open files:
> > >
> > > $ bin/smbclient -U 'USER%PASS' //IP/C\$
> > > smb: \> cd Users\administrator.WINCLUSTER\Desktop\
> > > smb: \Users\administrator.WINCLUSTER\Desktop\> open
> > > t-ph-oplock-b-downgraded-s.cab
> > > open file
> > > \Users\administrator.WINCLUSTER\Desktop\t-ph-oplock-b-downgraded-s.cab:
> > > for read/write fnum 1
> > > smb: \Users\administrator.WINCLUSTER\Desktop\> rename
> > > t-ph-oplock-b-downgraded-s.cab renamed
> > > smb: \Users\administrator.WINCLUSTER\Desktop\>
> > >
> > > ...given the open is with SHARE_DELETE (had to tweak smbclient to
> > > actually allow that).
> >
> > Interesting.
> >
> > cifs.ko will get STATUS_ACCESS_DENIED when attempting to rename the open
> > file.  The file was open with SHARE_READ|SHARE_WRITE|SHARE_DELETE, BTW.
> >
> > Also, note that cifs.ko will not reuse the open handle, rather it will
> > send a compound request of create+set_info(rename)+close to the file
> > which will fail with STATUS_ACCESS_DENIED.
> >
> > What am I missing?
> >
> > > If the rename destination is open and the server rightly fails the
> > > rename for that reason, then masking that error is a mistake imho.
> > >
> > > When doing
> > >
> > > $ mv a b
> > >
> > > the user asked to rename a, he did NOT ask to rename b which becomes
> > > important, because if you do
> > >
> > > rename("b", ".renamehackXXXX")
> > >
> > > under the hood and then reattempt the rename
> > >
> > > rename("a", "b")
> > >
> > > and then the user subsequently does
> > >
> > > $ mv b ..
> > > $ cd ..
> > > $ rmdir DIR
> > >
> > > where DIR is the directory all of the above was performed inside, the
> > > rmdir will fail with ENOTEMPTY and *now* the user is confused.
> >
> > Yes, I understand your point.  That's really confusing.
> >
> > How can we resolve above cases without performing the silly renames
> > then?
> >
>
> I think you can't.  CIFS, without the posix extensions, is basically
> not posix and never will be.
> You can make it close but it will never be perfect and you will have
> to decide on how/what posix semantics you need to give up.
>
> What compounds the issue is that cifs on linux (without the posix
> extensions) will also always be a second class citizen.
> Genuine windows clients own this protocol and they expect their own
> non-posix semantics for their vfs, so you can't do anything that
> impacts windows clients, they are the first class citizen here.
>
> The two main issues I see with the silly renames are the "-ENOTEMPTY"
> error when trying to delete the "empty" directory, but also
> that you can not hide them from windows clients. And what happens if
> the windows clients start accessing them?
>
> I think the only real solution is to say "if you need posix semantics
> then you need to use the posix extensions".

Another potential issue is about QUERY_INFO.
Many of the information classes in FSCC return the filename as as part
of the data.
What filename should be returned for a silly renamed file?

Maybe it doesn't matter  but maybe there is some obscure windows
application out there that do care and gets surprised.
