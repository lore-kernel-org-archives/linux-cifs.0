Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89DDF45029
	for <linux-cifs@vger.kernel.org>; Sun, 31 Aug 2025 12:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756644908; cv=none; b=AsRK71ttNDcXPjWEH+bSosKFTEoM3lh6pasAtauBw0p5JoQqycUDBTpjYIuvmBScvW0zGe8WG9fQhXUbFPd+xRD7fec/xnBweJND83v4qtYLdPMJPvK7tOoIHBTi7eD8qoyuDwU7BcuJysssUhSUJpaQFimBY36eW/EUbZstNBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756644908; c=relaxed/simple;
	bh=kiFFe3mgqJBmcgGxYQ+jbqxD6G/Pr9zpMAMawQMGJiY=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BpA+zJeDzL/XWOz02eKR5gdA6YXJeR3JCE17iY4RKMOAjERmkXRm1jtCzBZXdzuEZ/3QGrVcK9H0GcuC12+t50jGvgsZ68STvcvfUN4iDSH7KSXV6MLzW4kCfTyHzV64th9J45VW3arA8lqxCPT4FNQK7DLOrfM4WCd4cA3wOhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JfRmB8Tp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JfRmB8Tp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA734C4CEED;
	Sun, 31 Aug 2025 12:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756644908;
	bh=kiFFe3mgqJBmcgGxYQ+jbqxD6G/Pr9zpMAMawQMGJiY=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=JfRmB8TpA3Z/FAJIiangOZYzy6dcH4ltdL3P+tfstjy2cQcX3LMFI3WRrlIROr03J
	 HUj9zUWENJekIHZP5WlbtbrO5GtwH1pCwPQj5dBh8JRK6DOhRwVfH2wRXqj6aXnvKN
	 QU/jy5mO/HjIJNxzC74xwKfsGUv7cC6I2fk+hyDtvGX71EQYr9GuOH9tCo22oimpzw
	 H/aIMk4SfymiMB1w7sqVJj1NuUD/DMfXGLK0eccbamz6qE05iuV48PPMayUw5EfNZ/
	 UIgrR0T8npNEIltObA3tHlyFXVVv29V+MPZgRtz34uwKMAwFtIF858BKzxm2Zkl0li
	 8wKTr1J1EEI9A==
Received: by pali.im (Postfix)
	id 49731598; Sun, 31 Aug 2025 14:55:05 +0200 (CEST)
Date: Sun, 31 Aug 2025 14:55:05 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Ralph Boehme <slow@samba.org>, smfrench <smfrench@gmail.com>,
	tom <tom@talpey.com>, CIFS <linux-cifs@vger.kernel.org>
Subject: Re: [EXTERNAL] Fwd: SMB2 DELETE vs UNLINK -
 TrackingID#2504090040009564
Message-ID: <20250831125505.4ggqt2bzz4rtzhqt@pali>
References: <20250408224309.kscufcpvgiedx27v@pali>
 <6f5031e9-36d4-4521-a07a-6892cc5ce8a3@samba.org>
 <MWHPR21MB45241411805698FB51F0F4F294B42@MWHPR21MB4524.namprd21.prod.outlook.com>
 <LV2PR21MB31576391E902DD819ADE3A5AC6B72@LV2PR21MB3157.namprd21.prod.outlook.com>
 <LV2PR21MB315742A5FFB78BC2889E138AC689A@LV2PR21MB3157.namprd21.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <LV2PR21MB315742A5FFB78BC2889E138AC689A@LV2PR21MB3157.namprd21.prod.outlook.com>
User-Agent: NeoMutt/20180716

Hello Ralph,

In [MS-SMB] 54.0 from 8/11/2025 in Change Tracking section
http://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-smb/4caa15a3-700f-479f-90ce-53e2ecca945d
is now documented that TRANS2_SET_FILE_INFORMATION supports
FileDispositionInformationEx which allows to do POSIX unlink.

And now also [MS-FSA] was updated for POSIX semantics support.
In version 41.0 from 8/11/2025 is in Change Tracking section
https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-fsa/78f36c85-889c-4804-ab11-6af3565e01b1
documented new volatile field DeleteUsingPosixSemantics and other
sections were extended for POSIX support, including the description how
to handle FileDispositionInformationEx requests.

Pali

On Tuesday 06 May 2025 19:00:17 Obaid Farooqi wrote:
> Hi Ralph:
> FileDispositionInformationEx, is for use locally, as documented in MS-FSCC. MS-SMB2 and MS-SMB both do not support it but Pali have been able to use MS-SMB pass-through mechanism to send this information level to the object store who acts on it and deletes the file.
> MS-FSCC is already updated and you can see the changes in the current release.
> MS-SMB was updated as follows:
> "
> <133> Section 3.3.5.10.6:
> ...
> If Information Level is set to an undefined value (0x0428) in the request, Windows Server 2022
> does not process the request but sends a success response.
> "
> The above statement is to document the pass through behavior that Pali was able to produce. This does not tell the whole story, so I have filed a bug to make it more complete.
> 
> MS-FSA does not mention FileDispositionInformationEx. The reason is because FileDispositionInformationEx is local. But since Pali has been able to send FileDispositionInformationEx on the wire, I have filed a bug to add a section about FileDispositionInformationEx and information about POSIX semantics.
> 
> Please let me know if this does not answer your question.
> 
> Regards,
> Obaid Farooqi
> Escalation Engineer | Microsoft
> 
> -----Original Message-----
> From: Obaid Farooqi
> Sent: Thursday, April 10, 2025 6:07 AM
> To: Ralph Boehme <slow@samba.org>
> Cc: smfrench <smfrench@gmail.com>; tom <tom@talpey.com>; Pali Rohár <pali@kernel.org>; CIFS <linux-cifs@vger.kernel.org>; Microsoft Support <supportmail@microsoft.com>
> Subject: RE: [EXTERNAL] Fwd: SMB2 DELETE vs UNLINK - TrackingID#2504090040009564
> 
> Hi Ralph, Tom:
> I'll help you with this issue and will be in touch as soon as I have an answer.
> 
> Regards,
> Obaid Farooqi
> Escalation Engineer | Microsoft
> -----Original Message-----
> From: Michael Bowen <Mike.Bowen@microsoft.com>
> Sent: Wednesday, April 9, 2025 8:57 PM
> To: Ralph Boehme <slow@samba.org>
> Cc: smfrench <smfrench@gmail.com>; tom <tom@talpey.com>; Pali Rohár <pali@kernel.org>; CIFS <linux-cifs@vger.kernel.org>; Microsoft Support <supportmail@microsoft.com>
> Subject: RE: [EXTERNAL] Fwd: SMB2 DELETE vs UNLINK - TrackingID#2504090040009564
> 
> [DocHelp to bcc]
> 
> Hi Ralph,
> 
> Thanks for your question about SMB2. We've created case number 2504090040009564 to track this issue. One of our engineers will contact you soon.
> 
> Best regards,
> Michael Bowen
> Microsoft Open Specifications Support
> 
> -----Original Message-----
> From: Ralph Boehme <slow@samba.org>
> Sent: Tuesday, April 8, 2025 11:51 PM
> To: Interoperability Documentation Help <dochelp@microsoft.com>
> Cc: smfrench <smfrench@gmail.com>; tom <tom@talpey.com>; Pali Rohár <pali@kernel.org>; CIFS <linux-cifs@vger.kernel.org>
> Subject: [EXTERNAL] Fwd: SMB2 DELETE vs UNLINK
> 
> Hello dochelp,
> 
> it seems the updates for POSIX unlink and rename made it into MS-FSCC
> 
> <https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-fscc/f1f88b22-15c6-4081-a899-788511ae2ed9>
> 
> but I don't see accompanying updates to MS-FSA and, if supported over SMB, MS-SMB2.
> 
> Is this coming? If this is supported over SMB by Windows it is not sufficient to have it burried in MS-FSCC. :)
> 
> Thanks!
> -slow
> 
> -------- Forwarded Message --------
> Subject: Re: SMB2 DELETE vs UNLINK
> Date: Wed, 9 Apr 2025 00:43:09 +0200
> From: Pali Rohár <pali@kernel.org>
> To: linux-cifs@vger.kernel.org
> CC: Tom Talpey <tom@talpey.com>, Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>, Namjae Jeon <linkinjeon@kernel.org>, Ralph Boehme <slow@samba.org>
> 
> On Friday 27 December 2024 19:51:30 Pali Rohár wrote:
> > On Friday 27 December 2024 11:43:58 Tom Talpey wrote:
> > > On 12/27/2024 11:32 AM, Pali Rohár wrote:
> > > > On Friday 27 December 2024 11:21:49 Tom Talpey wrote:
> > > > > Feel free to raise the issue yourself! Simply email "dochelp@microsoft.com".
> > > > > Send as much supporting evidence as you have gathered.
> > > > >
> > > > > Tom.
> > > >
> > > > Ok. I can do it. Should I include somebody else into copy?
> > >
> > > Sure, you may include me, tell them I sent you. :)
> > >
> > > Tom.
> > >
> >
> > Just note for others that I have already sent email to dochelp.
> 
> Hello, I have good news!
> 
> dochelp on 04/07/2025 updated MS-FSCC documentation and now it contains the structures to issue the POSIX UNLINK and RENAME operations.
> 
> https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-fscc/f1f88b22-15c6-4081-a899-788511ae2ed9
> MS-FSCC 7 Change Tracking
> 
> https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-fscc/2e860264-018a-47b3-8555-565a13b35a45
> MS-FSCC 2.4.12 FileDispositionInformationEx has FILE_DISPOSITION_POSIX_SEMANTICS
> 
> https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-fscc/4217551b-d2c0-42cb-9dc1-69a716cf6d0c
> MS-FSCC 2.4.43 FileRenameInformationEx has FILE_RENAME_REPLACE_IF_EXISTS
> + FILE_RENAME_POSIX_SEMANTICS
> 
> https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-fscc/ebc7e6e5-4650-4e54-b17c-cf60f6fbeeaa
> MS-FSCC 2.5.1 FileFsAttributeInformation has FILE_SUPPORTS_POSIX_UNLINK_RENAME
> 
> So now both classic Windows DELETE and POSIX UNLINK is available and documented.
