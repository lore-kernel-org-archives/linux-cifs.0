Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACFE14437A;
	Sun, 15 Dec 2024 09:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734254740; cv=none; b=mocN9t3ZvMo/vTFXTaiDxpptFGyK4W0IVt6wO2ITGkUDeTKpcPmEEXCeVr8uufjez8TtfWSFSkGaqCde+WV9ccE41aTGRpwqT4RXI0weYqtRrU9Kc9BdMiXJPJbRern5vlRxdLTuSBpxvHQSwVQy4sElQ/lmkjARVcL4cs2EjtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734254740; c=relaxed/simple;
	bh=n5sgv/yHJHqT+g+r76/KJjMHQA2PFotryeScYqJ16P8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SxqItfZotBj0UN+2jpXyGcL+mJLsQ4GIR6Fxl6YNCXxOZfUMRvjy/h9+UPe6wHQNc2keRl24AnDA1v0TJvXzBDpsZX+j6vFCBbKeYrp3PVouHxfpmay2pzVXEUdIEQr+FaR8FTssQLBwfY6PRXv+aDWLDfSkP1UBw31kg1CWCL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=leh0GujJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="leh0GujJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFD4AC4CECE;
	Sun, 15 Dec 2024 09:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734254740;
	bh=n5sgv/yHJHqT+g+r76/KJjMHQA2PFotryeScYqJ16P8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=leh0GujJ13SNYMeNkf2gf5Yk8ook8S4bRb3lzDD/nj6k60Yq74N7r9kwB0sValSxs
	 QYtid9sAMfJ2KilwWSRrtyW1C/4XXQVhiuu9eTo4SAqOuuD2lBDB+4FBwJTfGaa7Ta
	 pGTuk/dQB5eALr3FTaL/La6i60EMMRfRkn+yixKQ=
Date: Sun, 15 Dec 2024 10:25:37 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Salvatore Bonaccorso <carnil@debian.org>
Cc: Michael Krause <mk@galax.is>, Paulo Alcantara <pc@manguebit.com>,
	Michael Krause <mk-debian@galax.is>,
	Steve French <stfrench@microsoft.com>, stable@vger.kernel.org,
	regressions@lists.linux.dev, linux-cifs@vger.kernel.org
Subject: Re: backporting 24a9799aa8ef ("smb: client: fix UAF in
 smb2_reconnect_server()") to older stable series
Message-ID: <2024121515-ranch-cassette-84f7@gregkh>
References: <2024040834-magazine-audience-8aa4@gregkh>
 <Z0rZFrZ0Cz3LJEbI@eldamar.lan>
 <2e1ad828-24b3-488d-881e-69232c8c6062@galax.is>
 <1037557ef401a66691a4b1e765eec2e2@manguebit.com>
 <Z08ZdhIQeqHDHvqu@eldamar.lan>
 <3441d88b-92e6-4f89-83a4-9230c8701d73@galax.is>
 <2024121243-perennial-coveting-b863@gregkh>
 <e9f36681-2d7e-4153-9cdf-cf556e290a53@galax.is>
 <2024121316-refresh-skintight-c338@gregkh>
 <Z1xYf9ShY2OuNiZo@eldamar.lan>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z1xYf9ShY2OuNiZo@eldamar.lan>

On Fri, Dec 13, 2024 at 04:53:35PM +0100, Salvatore Bonaccorso wrote:
> Hi Greg,
> 
> On Fri, Dec 13, 2024 at 03:33:31PM +0100, Greg KH wrote:
> > On Thu, Dec 12, 2024 at 10:48:55PM +0100, Michael Krause wrote:
> > > On 12/12/24 1:26 PM, Greg KH wrote:
> > > > On Tue, Dec 10, 2024 at 12:05:00AM +0100, Michael Krause wrote:
> > > > > On 12/3/24 3:45 PM, Salvatore Bonaccorso wrote:
> > > > > > Paulo,
> > > > > > 
> > > > > > On Tue, Dec 03, 2024 at 10:18:25AM -0300, Paulo Alcantara wrote:
> > > > > > > Michael Krause <mk-debian@galax.is> writes:
> > > > > > > 
> > > > > > > > On 11/30/24 10:21 AM, Salvatore Bonaccorso wrote:
> > > > > > > > > Michael, did a manual backport of 24a9799aa8ef ("smb: client: fix UAF
> > > > > > > > > in smb2_reconnect_server()") which seems in fact to solve the issue.
> > > > > > > > > 
> > > > > > > > > Michael, can you please post your backport here for review from Paulo
> > > > > > > > > and Steve?
> > > > > > > > 
> > > > > > > > Of course, attached.
> > > > > > > > 
> > > > > > > > Now I really hope I didn't screw it up :)
> > > > > > > 
> > > > > > > LGTM.  Thanks Michael for the backport.
> > > > > > 
> > > > > > Thanks a lot for the review. So to get it accepted it needs to be
> > > > > > brough into the form which Greg can pick up. Michael can you do that
> > > > > > and add your Signed-off line accordingly?
> > > > > Happy to. Hope this is in the proper format:
> > > > 
> > > > It's corrupted somehow:
> > > > 
> > > > patching file fs/smb/client/connect.c
> > > > patch: **** malformed patch at line 202:  		if (rc)
> > > > 
> > > > 
> > > > Can you resend it or attach it?
> > > > 
> > > > thanks,
> > > > 
> > > > greg k-h
> > > 
> > > Ugh, how embarrassing. I'm sorry, I "fixed" some minor whitespace issue directly in the patch and apparently did something wrong.
> > > 
> > > I redid the white space fix before diffing again and attach and inline the new version. The chunks are a bit alternated to the earlier version now unfortunately. This one applies..
> > 
> > Doesn't apply for me:
> > 
> > checking file fs/smb/client/connect.c
> > Hunk #1 FAILED at 259.
> > Hunk #2 FAILED at 1977.
> > Hunk #3 FAILED at 2035.
> > 3 out of 3 hunks FAILED
> > checking file fs/smb/client/connect.c
> > 
> > Any ideas?
> 
> Hmm, that is strange. I just did the follwoing:
> 
> $ git branch 6.1.y-backport-smb-uaf-smb2_reconnect_server v6.1.119
> $ git checkout 6.1.y-backport-smb-uaf-smb2_reconnect_server
> $ git am /tmp/backport-6.1-smb-client-fix-UAF-in-smb2_reconnect_server.v2.patch
> Applying: smb: client: fix UAF in smb2_reconnect_server()
> .git/rebase-apply/patch:102: space before tab in indent.
>         spin_unlock(&ses->ses_lock);
> warning: 1 line adds whitespace errors.
> 
> The warning looks correct, there is a space before the indent here:
> 
> [...]
> 180 +^Ido_logoff = ses->ses_status == SES_GOOD && server->ops->logoff;$
> 181 +^Ises->ses_status = SES_EXITING;$
> 182 +^Itcon = ses->tcon_ipc;$
> 183 +^Ises->tcon_ipc = NULL;$
> 184 + ^Ispin_unlock(&ses->ses_lock);$  <--- space before the indent
> tab
> 185 +^Ispin_unlock(&cifs_tcp_ses_lock);$
> 186  $
> 187 -^Iif (ses->ses_status == SES_EXITING && server->ops->logoff) {$
> [...]

Ok, this looks like it was a base64 issue on my side, with my tools,
sorry about that.  Now queued up!

greg k-h
