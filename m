Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6307139D19
	for <linux-cifs@vger.kernel.org>; Wed, 13 Nov 2024 16:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731516702; cv=none; b=S2TpHNP4cRi6dHSPb5sk/rwyJ877WIrtbAvQJ3+wzqJ7M/RcUYaom1N1ozZnHj8l7AedW7Ia+CS75n9fByRV9VDwAZZu3nV7WSabEi33P+Ngk+3/y6c4qTJwGhdDK5GQjUcVSb5di9DwGPPOTHo0SoIbhI7YCSa1Qn9egPL+7tU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731516702; c=relaxed/simple;
	bh=E36oUNi+ZAnx+x7K2+0JFnEYvmHI/7fUb+/NsB6+VhM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SmyHXGwb8iu7HbiVVaoKGaCWER6w1bjR4CowEJG0wv1HT8/GGAh7Z/zFJGqbzFxxU67qN5g4qZ1Ory3mi+32ITHiOTfexk9g/ONf5570p+RrRA9AbgYEGuZyPTno2LGYWTSzSx51SC9FvzlPrJlALGhdD8LTNZxahOjui9FZPYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BOoD6Etw; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BOoD6Etw"
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-53d9ff92edaso1344010e87.1
        for <linux-cifs@vger.kernel.org>; Wed, 13 Nov 2024 08:51:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731516698; x=1732121498; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dE864EhtIfMkRBC1u6MYG0lxFsdn8lJIvGm2U+vVyPs=;
        b=BOoD6Etws+VgS0DAUmSPQod4y76G8e+y8WJ5C2cx1DFPjcObRABULcEFqRLWL8Lzzv
         zPooqDdhnAIvUauxHeOtZ2AsvhjEOrmTpbMfkkaBxfWoiQf1EZKSX9+5TeJMH9+VoRbU
         d83ti7qaXciqUjMvNwvP6GC0ISa/cW5xgLE9OK0IjuEQKjngJubtYOxzxNwyn/ViepBP
         MzLcvblVCweHZs3dSKnhBt14DbUccg+uBc1502duuDmcyEaFqNPDUsIKsyI3yhQd8bdC
         xFz2l4knU0UtOrO61wYJjR48MsgMcqD1n2LDAtaeBNTh7hc4+zGXj3LplIJM8KTYKceM
         rLHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731516698; x=1732121498;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dE864EhtIfMkRBC1u6MYG0lxFsdn8lJIvGm2U+vVyPs=;
        b=msyC0lmLo5m//Wq55WWwZruQq3B7KnCNbBBnpEYjHg/s42Oz9mKaQsF9x0gme5n63v
         ZFtx7PvqNRMwVS9FOQhe9nPbmm4+cJQVUql3VpSZ0YqOgftDrbMynpvB9vM/wjxg+PJo
         eUlzLzFO349J86PLPJJJitRAOi1giUA+1hCfh3H5idHppLyuMNcScLFxJC+7YEYCpPBW
         CLy3+RFkZ0wtwGHUvnMYdBe3+QYxmJjPX4cjQDNVJNMk4bqu8sobYXC31rGPvbS1BaUR
         g+ezsL39YOrssdvyQTSe8Mt/LwL7r7vQuGLo/XPLRQQ1XAqT0xoAL6vjufxRcRMeKBGQ
         YuCg==
X-Forwarded-Encrypted: i=1; AJvYcCU/z8+BfqWoNq0JsnOoYhWxS3zkLFzJ0BYFCTqvVDPYzaAPn/TI+RqPym3SwjqaYUSz9MyRTN37HNmP@vger.kernel.org
X-Gm-Message-State: AOJu0YwYnGs3vApwJ30SWGLoBMOZ4sbzsUGQzWDT+9839xmJiNhSL4E0
	ux5/ZoJx+UrgV3436g2/LpsoDFSRD4kBi5frzA7gqb/JCZ3a32a3pgpa8qXIpn2/5Y4pkZYMssg
	hiA3fVNPm9ovqukHoJzl6XkAm2+Tt1Q==
X-Google-Smtp-Source: AGHT+IEBLysDHm3WrcOhLJzVFi9TJ9DDNIw7M8kYwesCGsWb22uPMpFsTryZm5mkDEqi39Il30J9gZtR2DWCElY58Ho=
X-Received: by 2002:ac2:4c4d:0:b0:53d:a2b5:d8b9 with SMTP id
 2adb3069b0e04-53da2b5db31mr1205709e87.34.1731516697742; Wed, 13 Nov 2024
 08:51:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241030142829.234828-1-meetakshisetiyaoss@gmail.com>
 <1f8a225b0d16fdfa05c417e0f6602489@manguebit.com> <CANT5p=rm90eHDeA669yRNdKvT=GL+NE1PVTJVS-htQ8pbfiwUA@mail.gmail.com>
 <CANT5p=pFCbi1H-JzRLx5XqL4Qwy-YbOWAX6XmoWXezSn2i__mQ@mail.gmail.com>
 <b8164b0a49ad6d4cd60142fa55ad3566@manguebit.com> <CAFTVevVGMfkgsr31nN35-p+2nQZEXhHK8hPPF1EhfLmdtKdw+A@mail.gmail.com>
 <CAFTVevVa81C3u5Wdc+egz8ZbSrNKF7uy6m=6Nd5YnKfeMfo1sA@mail.gmail.com>
In-Reply-To: <CAFTVevVa81C3u5Wdc+egz8ZbSrNKF7uy6m=6Nd5YnKfeMfo1sA@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Wed, 13 Nov 2024 10:51:26 -0600
Message-ID: <CAH2r5mv-uMJmfZ-4cuOBd0O2v6=rntaMbfggyXqtF4hQXHtvBw@mail.gmail.com>
Subject: Re: [PATCH 1/2] cifs: during remount, make sure passwords are in sync
To: Meetakshi Setiya <meetakshisetiyaoss@gmail.com>
Cc: Paulo Alcantara <pc@manguebit.com>, Shyam Prasad N <nspmangalore@gmail.com>, sfrench@samba.org, 
	sprasad@microsoft.com, tom@talpey.com, linux-cifs@vger.kernel.org, 
	bharathsm.hsk@gmail.com, Meetakshi Setiya <msetiya@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

My opinion is that since password rotation is important for various
security scenarios, there is value in improving it for all dialects,
especially as the missing piece in the SMB1 reconnect path shouldn't
be too hard to fix.

On Wed, Nov 13, 2024 at 4:00=E2=80=AFAM Meetakshi Setiya
<meetakshisetiyaoss@gmail.com> wrote:
>
> Typo: password rotation for SMB1.0 is NOT supported for reconnects. It wo=
rks for fresh
> mounts and remounts.
> Should I add support for reconnect or remove it completely?
>
> On Wed, Nov 13, 2024 at 3:20=E2=80=AFPM Meetakshi Setiya <meetakshisetiya=
oss@gmail.com> wrote:
>>
>> Hi Paulo,
>>
>> Given your and Shyam's comments, I am thinking of making the
>> following changes to the code to support password rotation for DFS:
>>
>> 1. For a fresh mount:
>>     - In cifs_do_automount, bring the passwords in fs_context in sync wi=
th
>>     the passwords in the session object before sending the context to th=
e
>>     child/submount.
>>
>> 2. For a remount (of the root only):
>>     - In smb3_reconfigure, bring the passwords in the fs_context of the =
master
>>     tcon in sync with its session object passwords. After this is done, =
a new
>>     function will be called to iterate over the dfs_ses_list held in thi=
s tcon
>>     and sync their session passwords with the updated root session passw=
ord
>>     and password2.
>>
>> Password rotation for multiuser mounts is out of scope for this patch an=
d I will
>> address it later.
>>
>> Please let me know if you have any comments or suggestions on this appro=
ach.
>>
>> Also, we share the mount code path (cifs_mount) for all SMB versions. So=
, password
>> rotation for SMB1.0 is currently supported ONLY on mounts. Password rota=
tion on
>> remount, however, is not. Should I remove the support completely for SMB=
1.0
>> (print a warning message), leave it be, or add remount support?
>
>
> reconnect, not remount.
>
>>
>> Thanks
>> Meetakshi
>>
>> On Mon, Nov 11, 2024 at 5:34=E2=80=AFPM Paulo Alcantara <pc@manguebit.co=
m> wrote:
>>>
>>> Shyam Prasad N <nspmangalore@gmail.com> writes:
>>>
>>> > On Fri, Nov 8, 2024 at 5:47=E2=80=AFPM Shyam Prasad N <nspmangalore@g=
mail.com> wrote:
>>> >> > What about SMB sessions from cifs_tcon::dfs_ses_list?  I don't see=
 their
>>> >> > password getting updated over remount.
>>> >>
>>> >> This is in our to-do list as well.
>>> >
>>> > I did some code reading around how DFS automount works.
>>> > @Paulo Alcantara Correct me if I'm wrong, but it sounds like we make
>>> > an assumption that when a DFS namespace has a junction to another
>>> > share, the same credentials are to be used to perform the mount of
>>> > that share. Is that always the case?
>>>
>>> Yes, it inherits fs_context from the parent mount.  For multiuser
>>> mounts, when uid/gid/cruid are unspecified, we need to update its value=
s
>>> to match real uid/gid from the calling process.
>>>
>>> > If we go by that assumption, for password2 to work with DFS mounts, w=
e
>>> > only need to make sure that in cifs_do_automount, cur_ctx passwords
>>> > are synced up to the current ses passwords. That should be quite easy=
.
>>>
>>> Correct.  The fs_context for the automount is dup'ed from the parent
>>> mount.  smb3_fs_context_dup() already dups password2, so it should work=
.
>>>
>>> The 'remount' case isn't still handled, that's why I mentioned it above=
.
>>> You'd need to set password2 for all sessios in @tcon->dfs_ses_list.
>>>
>>> I think we need to update password2 for the multiuser sessions as well
>>> and not only for session from master tcon.



--=20
Thanks,

Steve
