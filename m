Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 961A629D0E
	for <linux-cifs@vger.kernel.org>; Wed,  3 Sep 2025 19:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756929358; cv=none; b=BjM4CLJAulknK2WH2aFEkPx1bWxe2cJqc1AAxvao1HeHLMsYzoS9wymRhuIpo2mu0kH1sbRvVonEVQBzNKpFFeLzEgKR/Zy+aL4uoyw2+Pc3qpagRSgbeOSuyL7lr6u/D3zq02t+5A3450jPTl4PMqjS7GHoVWYCxP5ol/Zh544=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756929358; c=relaxed/simple;
	bh=bMw+7wVmDl1RqJThLW3Wz4Bb8TAqAQ+oAjVw1Z2jIEE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AKJOSg15yiaQjSpL1xQGVBbrD8p4D8XmgzXjRZEIQIM7bJt+qDUsooLVsTmbAchZsWknnGR+vMgwgFmHNVHpl2O9eUaYsJWf3oOZLV8VeX1fTsASRJgNmHpOsaCZQAe6cdSoW/BvO9bQVbfTYbSZzgqPZ6qet1tPSLaHrRyW0Ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JUKlwOrQ; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JUKlwOrQ"
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-b4d4881897cso158418a12.0
        for <linux-cifs@vger.kernel.org>; Wed, 03 Sep 2025 12:55:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756929356; x=1757534156; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=vAoYlf1xKxHbRXZL4N/DRBMyAEwj81s1QpXLm3NAPX8=;
        b=JUKlwOrQPOfkNA6yDuuWTxWGwZF7J/FA0YdOrHrnWYKK8DP5QvtVlShr/Y0p1MZapO
         2KZ1xCPqa4L492cKm7qDsLd5XQvlv8JBD8/RSmcxRw+SdZbqMk5kn0g6XwqcTBMOwJB7
         cZ3jWmW2SIBUxIpVC8x+0On1S9bXTBe3zjqfacVSdp2eHT8lZuWJFSEWtUyQInDIgmLY
         wX3puR2jrWbsZaGGkBCEqyXY8KCtmHK9uQdqybzCA810AebUpo33MXsoEJ9dfvcQu6xm
         5dK5caAnsjy8+v8UzEHXIl+2lvmrpgC0uDn881DGzRzzIA86j0q36/zrvnS64yKe5zfo
         kS8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756929356; x=1757534156;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vAoYlf1xKxHbRXZL4N/DRBMyAEwj81s1QpXLm3NAPX8=;
        b=hNUjexulx9vuCjZFkjAwzYJLGFf5xgHzIoa9huP3jVCUbjjoY+M00YJnANqgSOZti4
         qUZQa6xfjiJ9bY3/VPLEr9mMGewtOpcbLW463BQIAijGPxtlzXGmbulWJeoOgXpFnBAY
         p8QuxWFkTmEvKYd6WmC4AEjyL3FnrdJCt7K7IQWEm4Gcjojz3Q0GXNyOTqLxo6TpTKJE
         jgv1oaPWR1eyp6QWpa7lgpNDGuRN0saSLaMbUjeC8ovWV+MTuzrCixP4swOgf3Af22lJ
         yCYWpu1enYtxEsWzCaQiZsxplBDgsvY/74L14QuODl4C5i/BdJTOa6pEL2pGOU6tZU9I
         0pLQ==
X-Forwarded-Encrypted: i=1; AJvYcCVzuY/r6k5znfZaY008y2B1z8aTTJJw6rWEYnuD3zZhHLtjXxME0wWfit1gA7vTR3aODXLgttx4RDsN@vger.kernel.org
X-Gm-Message-State: AOJu0Yw2xvM+YbAnU5PhEfxCLSk5hy9fJbu+Ja8wxNpTAYxI1fB7aXrg
	VNvUNjns2M9qW+Z4D1EsoRLeKCjriwQ+yw+Nd4YH20pgjA1WVC0w1ScdAJZghJCgQkI6+7zJQeE
	h2ggYRhTtVdPxgC3w9tTCWxCJtMUWV5c=
X-Gm-Gg: ASbGncughR9SXvIPb6ItcNPz6JSvuCqPqzzyM+IkHZbsvFIXuUqZlP7xFF2RySq0pzy
	ltbK1bucq6CzDqCPJg2vVKwTgFjthEe2HOgUKMe3D7cWcR7RWOVPsjumwZhiheHvDoelu8Cdz2I
	FkCwd6POxxtq+8m2ZlOp0JSE43Ks3sGXeUOGpHmsvN2aRPNiIxy5xAR6Zl2ON/jz1qLCSrmf0vw
	v1v2Fz20AcMBAiv1i0m26TWgP0ngDr5uuCrAijitR3oi1bE1pr/RmqzmeYLjdK+bxzR
X-Google-Smtp-Source: AGHT+IHTnWKTzut7P+pHeiCJgkzax6JyU6skl86ihAxcWFj+hcsK4UwBODvn8PEho5p1yVXW0AIPqzb0WoQUnNjP8DY=
X-Received: by 2002:a17:90b:3d07:b0:327:6da5:d94c with SMTP id
 98e67ed59e1d1-32815437c67mr22528952a91.9.1756929355778; Wed, 03 Sep 2025
 12:55:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250902165451.892165-1-pc@manguebit.org> <cd16cf45-efc8-4324-9d40-0b92f15f179a@samba.org>
 <da2380aa8e3718066bfc151bf60e54ea@manguebit.org> <d3702a1b-0dfc-4d56-8f0c-0cd588f151b2@samba.org>
 <faf6c4eaa69a36617d65327b98ed105d@manguebit.org>
In-Reply-To: <faf6c4eaa69a36617d65327b98ed105d@manguebit.org>
From: ronnie sahlberg <ronniesahlberg@gmail.com>
Date: Thu, 4 Sep 2025 05:55:44 +1000
X-Gm-Features: Ac12FXy9ETPTDqZSG1_yq1pYgYuvx1k9riIc87e6E6xyPBWRD30ByzFVP22rhNw
Message-ID: <CAN05THSWdDsuqBTkdL5H2tjBwNgPeO4k6fYFEqkYS_P3oc0t8Q@mail.gmail.com>
Subject: Re: [PATCH v2] smb: client: fix data loss due to broken rename(2)
To: Paulo Alcantara <pc@manguebit.org>
Cc: Ralph Boehme <slow@samba.org>, smfrench@gmail.com, 
	Jean-Baptiste Denis <jbdenis@pasteur.fr>, Frank Sorenson <sorenson@redhat.com>, 
	Olga Kornievskaia <okorniev@redhat.com>, Benjamin Coddington <bcodding@redhat.com>, 
	Scott Mayhew <smayhew@redhat.com>, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 4 Sept 2025 at 04:46, Paulo Alcantara <pc@manguebit.org> wrote:
>
> Ralph Boehme <slow@samba.org> writes:
>
> > Hi Paulo,
> >
> > On 9/2/25 9:09 PM, Paulo Alcantara wrote:
> >> Ralph Boehme <slow@samba.org> writes:
> >>
> >>> Why not simply fail the rename instead of trying to implement some
> >>> clever but complex and error prone fallback?
> >>
> >> We're doing this for SMB1 for a very long time and haven't heard of any
> >> issues so far.  I've got a "safer" version [1] that does everything a
> >> single compound request but then implemented this non-compound version
> >> due to an existing Azure bug that seems to limit the compound in 4
> >> commands, AFAICT.  Most applications depend on such behavior working,
> >> which is renaming open files.
> >
> > maybe I'm barking of the wrong tree, but you *can* rename open files:
> >
> > $ bin/smbclient -U 'USER%PASS' //IP/C\$
> > smb: \> cd Users\administrator.WINCLUSTER\Desktop\
> > smb: \Users\administrator.WINCLUSTER\Desktop\> open
> > t-ph-oplock-b-downgraded-s.cab
> > open file
> > \Users\administrator.WINCLUSTER\Desktop\t-ph-oplock-b-downgraded-s.cab:
> > for read/write fnum 1
> > smb: \Users\administrator.WINCLUSTER\Desktop\> rename
> > t-ph-oplock-b-downgraded-s.cab renamed
> > smb: \Users\administrator.WINCLUSTER\Desktop\>
> >
> > ...given the open is with SHARE_DELETE (had to tweak smbclient to
> > actually allow that).
>
> Interesting.
>
> cifs.ko will get STATUS_ACCESS_DENIED when attempting to rename the open
> file.  The file was open with SHARE_READ|SHARE_WRITE|SHARE_DELETE, BTW.
>
> Also, note that cifs.ko will not reuse the open handle, rather it will
> send a compound request of create+set_info(rename)+close to the file
> which will fail with STATUS_ACCESS_DENIED.
>
> What am I missing?
>
> > If the rename destination is open and the server rightly fails the
> > rename for that reason, then masking that error is a mistake imho.
> >
> > When doing
> >
> > $ mv a b
> >
> > the user asked to rename a, he did NOT ask to rename b which becomes
> > important, because if you do
> >
> > rename("b", ".renamehackXXXX")
> >
> > under the hood and then reattempt the rename
> >
> > rename("a", "b")
> >
> > and then the user subsequently does
> >
> > $ mv b ..
> > $ cd ..
> > $ rmdir DIR
> >
> > where DIR is the directory all of the above was performed inside, the
> > rmdir will fail with ENOTEMPTY and *now* the user is confused.
>
> Yes, I understand your point.  That's really confusing.
>
> How can we resolve above cases without performing the silly renames
> then?
>

I think you can't.  CIFS, without the posix extensions, is basically
not posix and never will be.
You can make it close but it will never be perfect and you will have
to decide on how/what posix semantics you need to give up.

What compounds the issue is that cifs on linux (without the posix
extensions) will also always be a second class citizen.
Genuine windows clients own this protocol and they expect their own
non-posix semantics for their vfs, so you can't do anything that
impacts windows clients, they are the first class citizen here.

The two main issues I see with the silly renames are the "-ENOTEMPTY"
error when trying to delete the "empty" directory, but also
that you can not hide them from windows clients. And what happens if
the windows clients start accessing them?

I think the only real solution is to say "if you need posix semantics
then you need to use the posix extensions".
