Received: from mail-yx1-f44.google.com (mail-yx1-f44.google.com [74.125.224.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65BD021D3F3
	for <linux-cifs@vger.kernel.org>; Fri, 24 Oct 2025 18:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761330300; cv=none; b=n++RelkPDNFCT/RaIH28SWidiH1FSSDWimCWMFar7UuBt/0OWrpmQ/yihtkugNwJnL5Uz4JFjjF5O4hxl4U2TjdwuM6TfYDaIBECm1jx9DF3cEdqueP2uIvqIFGEbkNMx8ZAZKc1kop0tXlfbxRsSnifaHLCsRXS4+AuXHDUHEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761330300; c=relaxed/simple;
	bh=cBSJtitKBO+o15qRGRi/wYjs6x/9SJGsybI8Pi+qHx8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jnw5nXLymDloRGxmuvPVPKH9Y4ZedS0AEtLzYOAY0ZTQf+dV/RRnlPjkT4hac3W3dvSu5H8JQ035CIESrMRgPTnQuTOXYdqV011FBJz4ScXfte5IWCsjdgiGB+yQTyHY+vm4zbiEhx1h/hksI+WCVaeizrMIFsi1EbQD1cI5pmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N7bQmKXw; arc=none smtp.client-ip=74.125.224.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N7bQmKXw"
Received: by mail-yx1-f44.google.com with SMTP id 956f58d0204a3-63e1591183bso2362073d50.0
        for <linux-cifs@vger.kernel.org>; Fri, 24 Oct 2025 11:24:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761330297; x=1761935097; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KHSPZN3wbM03bQvnZvZpSyFC6EU9yMZQOKvapIaHQ2I=;
        b=N7bQmKXwi/RlKkq8+11lSR6VHAx/6Ntl48j5xW8DrYF9jNYtwLdUaNUaoqcHj3zHAy
         w1UWz//eFHGi00LbGv+XP9e2eZCmZAWzkumIQKeolFQS1AAsLCoGj7gr0dQSmi0A4RWC
         CVbXzZyiL1G/6nrDQ9q9geU7VV5RuG9+pVphXtTZxnD6vjZwwDv8f+E9+4Zp2UsgkKNG
         yo9sEJ8bOajNLVb8XQ8q+aIBVIL0HikAVQAjqFIswQz+TVOA+btqYqq+dno6Z6CqcTtF
         LyS+Xc2cqz5++ibaSGX3VmbMvzCOHJxb72vylW+CSaf2hSmN4+V033cgYWsaGwPzW/5i
         wyIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761330297; x=1761935097;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KHSPZN3wbM03bQvnZvZpSyFC6EU9yMZQOKvapIaHQ2I=;
        b=K2gQP1Q7jipzYwhZt6ZX8zXRyofPpFeTJTmiNFpjMdf7xLPwXRbZIC0j0QPBB5WDrd
         w51HePazfLOMx4eRhkmahJQruCEnBITNIRCo1gPCturkHGJb5S388B65XBVYoBlQ2s9C
         yGpMTjK8P2deUd9wsQExgD3YnCzjgRPo84ID5ZjzspxA5vRBG4ElQIobu6dH2MPX6rFP
         oE6m3yAvV/VzIOP2+wEAljf46Dvl0TEsutbQBDogay5aP3pmnDea3/w0tbPkNIRDQfx8
         WU849im2wurrFtrpCR8Fc6Sqm7v1HfJ/QfdkQa/MdkKcwUkSRnNs+TJaInOfRrMWIkSR
         z+kQ==
X-Gm-Message-State: AOJu0YxwXdCS26xRXwyVliPYBnxM0K5pqiw/UDYHc+3tREClKsQ2RLQO
	yyotOr9cRhANbQo+KJveCFa0czIgiES4xgSXMmW7+E13bzruLz/0pdsQwPxP9qLE9dBmHIgQoV0
	vbGkbxr9tktXYd8KdC3nwPOKqJmM99cuiU2b4Zsc=
X-Gm-Gg: ASbGncuHIZIg6K7W3qv6i0euZwySrWfYtoDNHkmDq6tGENmyoBSyIPIOfJWZz6UqEYe
	E/vtkNzOYNV5Ze0oJniWnTBrEJLYs5KaUDjzkZD4juW3oASOztMhBpW8Xo+tGw/zeXQ/3M4+tHH
	nLpl0iDldbcmX9K1tRqjgVokC30aUky2AaJ/smUNV4w6/OOvrRxbr0klxjt2DGjmVFG3vD7GH9J
	k02CDzTGh3QmqP9vyMhGhcIGeRWTTwKyEcdrVMQ9EL9NAO29TgIR705+r3U4Xir8b5KJ+24P2JG
	Apw48YDD/ft1MmRZx/QYLGSBsOO+lU8WiUOEnm4Vi/M0xB1EtdpqxoyLAtN4/qqO8xqzFrEp7Zd
	93w==
X-Google-Smtp-Source: AGHT+IEkbHPdc48f12F82LwPBGA2Vroms3Ci/Gsuk9skpdIffDEV2itf/B8/Nx6bL44xtb6fCyrtswP2XRORUWVuikI=
X-Received: by 2002:a05:690e:124a:b0:63c:efa7:ac32 with SMTP id
 956f58d0204a3-63f435a13e6mr2204617d50.43.1761330297243; Fri, 24 Oct 2025
 11:24:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAEAsNvQmV=xFsU-4jn9zC2DYoAUjXTS3qcsGNe7XUZEEXg1cLg@mail.gmail.com>
 <CANT5p=qktRuzfwwAceyQWYx0k47udy7C4uQc8FASwRWfSYL_ng@mail.gmail.com> <CAEAsNvSuhhJyqWkpwHBdmJZ6mx5tzD2x2hUmxCyjLf50BamsuA@mail.gmail.com>
In-Reply-To: <CAEAsNvSuhhJyqWkpwHBdmJZ6mx5tzD2x2hUmxCyjLf50BamsuA@mail.gmail.com>
From: Thomas Spear <speeddymon@gmail.com>
Date: Fri, 24 Oct 2025 13:24:19 -0500
X-Gm-Features: AWmQ_bmwkmvSiy4HJBAF1vgmb1nAiby4NQ8OQZFw0fhVKOPEjUFNJRDtMZg0lhs
Message-ID: <CAEAsNvQLEjJY0gCLacnKhar2z_w5Dp+xmGms=m38xp_cgq-+bw@mail.gmail.com>
Subject: Re: mount.cifs fails to negotiate AES-256-GCM but works when enforced
 via sysfs or modprobe options
To: Shyam Prasad N <nspmangalore@gmail.com>
Cc: linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Re-sending as plain-text -- apologies, as my phone seems to only want
to send emails as HTML, so it never made it to the list.

Hi Shyam, thank you for bringing this up. I've seen this link and this
is for Kubernetes, so I've raised a case with Microsoft to improve the
documentation elsewhere to make it more clear, and also mentioned the
testing Enzo did indicated that with AES-128-GCM disabled, the share
is still providing it in the cipher list, which isn't documented
behavior.

I also found this Stack exchange post where someone with a TrueNAS
device encountered the same issue:
https://unix.stackexchange.com/questions/766995/linux-smb-client-failed-to-=
connect-to-smb-server-forcing-aes-256/800613#800613

When I first found that, before I posted here, I suggested that user
should try enforcing it on the client as this document suggests.

That being said, this seems to only be a requirement for mounting the
share in a Linux VM but based on Enzo's comments, mounting the exact
same share in a Windows VM has no such requirement to enforce
AES-256-GCM on the client side.

N.B. configure 2 storage accounts: one with AES-128 only, and one with
AES-256 only. Attempt to mount both at the same time to different
paths in a Linux VM. One will always be rejected depending on the
client's settings. Then attempt to mount both at the same time to
different drive letters in a Windows VM, and they both mount
successfully.


Thank you,

Thomas

On Fri, Oct 24, 2025 at 7:34=E2=80=AFAM Thomas Spear <speeddymon@gmail.com>=
 wrote:
>
> Hi Shyam, thank you for bringing this up. I've seen this link and this is=
 for Kubernetes, so I've raised a case with Microsoft to improve the docume=
ntation elsewhere to make it more clear, and also mentioned the testing Enz=
o did indicated that with AES-128-GCM disabled, the share is still providin=
g it in the cipher list, which isn't documented behavior.
>
> I also found this Stack exchange post where someone with a TrueNAS device=
 encountered the same issue: https://unix.stackexchange.com/questions/76699=
5/linux-smb-client-failed-to-connect-to-smb-server-forcing-aes-256/800613#8=
00613
>
> When I first found that, before I posted here, I suggested that user shou=
ld try enforcing it on the client as this document suggests.
>
> That being said, this seems to only be a requirement for mounting the sha=
re in a Linux VM but based on Enzo's comments, mounting the exact same shar=
e in a Windows VM has no such requirement to enforce AES-256-GCM on the cli=
ent side.
>
> N.B. configure 2 storage accounts: one with AES-128 only, and one with AE=
S-256 only. Attempt to mount both at the same time to different paths in a =
Linux VM. One will always be rejected depending on the client's settings. T=
hen attempt to mount both at the same time to different drive letters in a =
Windows VM, and they both mount successfully.
>
>
> Thank you,
>
> Thomas
>
> On Fri, Oct 24, 2025, 3:18=E2=80=AFAM Shyam Prasad N <nspmangalore@gmail.=
com> wrote:
>>
>> On Tue, Oct 21, 2025 at 2:22=E2=80=AFAM Thomas Spear <speeddymon@gmail.c=
om> wrote:
>> >
>> > First time emailing here, I hope I'm writing to the correct place.
>> >
>> > I have an Azure Storage account that has been configured with an Azure
>> > Files share to allow only AES-256-GCM channel encryption with NTLMv2
>> > authentication via SMB, and I have a linux client which is running
>> > Ubuntu 24.04 and has the Ubuntu version of cifs-utils 7.0 installed,
>> > however after looking at the release notes for the later upstream
>> > releases I don't think this is specific to this version and rather it
>> > is an issue in the upstream.
>> >
>> > When I try to mount an Azure Files share over SMB, I get a mount error
>> > 13. However, if I do either of the following, I'm able to successfully
>> > mount.
>> >
>> > 1. Enable AES-128-GCM on the storage account
>> > 2. Keep AES-128-GCM disabled on the storage account, but enforce
>> > AES-256-GCM on the client side by running 'echo 1 >
>> > /sys/module/cifs/parameters/require_gcm_256' after loading the cifs
>> > module with modprobe.
>> >
>> > I can see after running modprobe that the parameter "enable_gcm_256"
>> > is set to Y (the default value) and the parameter "require_gcm_256" is
>> > set to N (also the default value)  so I believe the mount command
>> > should theoretically negotiate with the server, but it seems that no
>> > matter what I try, unless I require 256 bits on the client side by
>> > overwriting the "require_gcm_256" parameter, it will never mount
>> > successfully when the server only allows 256 bits.
>> >
>> > It seems like mount.cifs should look at the "enable_gcm_256" parameter
>> > and if it's "Y" try to use 256 bits at first, falling back to 128 bits
>> > if the server doesn't support it or throwing an error if the
>> > "require_gcm_256" parameter is set to the default "N" value, but I
>> > must admit I don't know if there's some reason that can't be done.
>> >
>> > Is this something that could be looked at and possibly improved? I'm
>> > unfortunately not a developer, but just a user interested in making
>> > better documentation so if this cannot be improved, I'll go ahead and
>> > get something written up and share it with downstream teams like Azure
>> > Files CSI driver -- on that note, I'll appreciate any clarification on
>> > why setting this specific parameter is required if this can't be
>> > improved.
>> >
>> > Thank you,
>> >
>> > Thomas Spear
>> >
>>
>> Hi Thomas,
>>
>> This is documented by Azure Files here:
>> https://learn.microsoft.com/en-us/troubleshoot/azure/azure-kubernetes/st=
orage/fail-to-mount-azure-file-share#minimumencryption
>>
>> I suggest you open a support case with Microsoft about this if this is
>> limiting your use case.
>>
>> --
>> Regards,
>> Shyam
