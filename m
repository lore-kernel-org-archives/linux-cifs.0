Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3404B158A3D;
	Mon, 16 Sep 2024 16:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726503792; cv=none; b=EMB9IahKA5HU1HS4ynDlE1X4Mijn/1Vi41Sjlizff2tAO6wTk0cJzzL+mK6qhzcumRLk+2ImXnuxdjF/rR6X98hybAc2Oa7H/yTJp+4uod5iguin/p/PtHiWqhbUR4T/Dabn3Qnvfmtf4BDuK+00g6inXfw/pA/no2awUaeFbAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726503792; c=relaxed/simple;
	bh=Qsjt7qD0LhRUGBiRx6aQesuI8S2gzTyu+mazC8eGZs4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t09Ig/roTC0r9Sk/0vg4a+cvgsSvXHO+/SOy7hiG9xYbxpyr2h5NM6r+GjbshBjcdY2G9X9jWH7In/2XDm6buZX/O9KK1zKHm7PqaoiEAq++KysKe8aRbah4xMMEjLDfhHpKiVMxPw2piyQz5e1GJUFpRdU0EyJ4uDVC/KnUkMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oHJw3yq6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oHJw3yq6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59EBEC4CEC4;
	Mon, 16 Sep 2024 16:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726503791;
	bh=Qsjt7qD0LhRUGBiRx6aQesuI8S2gzTyu+mazC8eGZs4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oHJw3yq6Du6a8THTjfBM+d4m2hAUqlngMFKVz1fCpmofXGfcNpyjxyCITKIUV/LcF
	 vDAd7NewiVOEKfcIL15Gkvu1I2dtnOMIl0CER0YobvTBOQaPmYZxLnDoOT3l46L3ks
	 VTUVBMIyL5i5pePB21R6KzMt+j2u46qIFjSTA64Qhs8nzfWTKEN/JsptKgU0MScBE3
	 pYEvxlWs6r3MKaeZrzctVpngytmau3LMFcXBhuILGqEgHQmdXSljPZfJJRzrKlR+4N
	 RiMxLtay1lIna7S9koivdPpTXPx2RFSlw6fDJ3L9xwA8LJiw/xXa1MPd2faQ6euVK4
	 dshdwQD0Bnwvg==
Received: by pali.im (Postfix)
	id CE16468B; Mon, 16 Sep 2024 18:23:05 +0200 (CEST)
Date: Mon, 16 Sep 2024 18:23:05 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Steve French <smfrench@gmail.com>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	CIFS <linux-cifs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/7] cifs: Fix creating of SFU fifo and socket special
 files
Message-ID: <20240916162305.vy5w5albdpuvtk2x@pali>
References: <20240912120548.15877-1-pali@kernel.org>
 <20240912120548.15877-7-pali@kernel.org>
 <20240913200721.7egunkwp76qo5yy7@pali>
 <CAH2r5mvEa8mUrK7mEKFiimkb1asTWA0p7ADz4937yoxM916RAw@mail.gmail.com>
 <20240913224248.k5tn2le3gau2prmo@pali>
 <CAH2r5mtgV=NkZVChDY-apdqkvM9KFkraRGy_jDCpLmFU6PFMAA@mail.gmail.com>
 <20240914081742.wlldjjlogrmk533i@pali>
 <20240915174126.ilxwoxlsfakgnl7d@pali>
 <CAH2r5muXcyMxc=F2WsTtwQyKZ9TL64TWEBzX7bXJqZky2g0TzA@mail.gmail.com>
 <20240915174824.ykabgcwujtjh6lub@pali>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240915174824.ykabgcwujtjh6lub@pali>
User-Agent: NeoMutt/20180716

Now I have tested this behavior against one Windows Server 2019 instance
and it works too. So confirmed, it is the case also for 2019 version.

On Sunday 15 September 2024 19:48:24 Pali Rohár wrote:
> It works for this new 2022 version and also for old 2012 version. So my
> personal guess is yes, that it would work also for 2019 (I do not see
> reason why something would not work for version in-the-middle). If
> needed, I may try to do this test against 2019 version during next or
> another weekend.
> 
> On Sunday 15 September 2024 12:42:27 Steve French wrote:
> > Do you know if this is the case for windows server 2019
> > 
> > On Sun, Sep 15, 2024, 12:41 PM Pali Rohár <pali@kernel.org> wrote:
> > 
> > > Hello Steve,
> > >
> > > I have another argument for the empty system file as fifo over the
> > > file with "LnxFIFO" content.
> > >
> > > Now I have figured out that even the latest Windows Server 2022 version
> > > provides interoperability of FIFOs in SFU format with Windows NFS 4.1
> > > Server. So if you configure on Windows Server 2022 one share which is
> > > exported over SMB and also NFS at the same time, and over SMB you create
> > > SFU-style fifo, then Windows NFS4.1 server recognize it and properly
> > > reports nfs4type as NFS4FIFO for NFSv4.1 client.
> > >
> > > So this SFU FIFO style is not only for old clients and servers, but
> > > still relevant and useful even for latest Windows Server.
> > >
> > > And same applies for named sockets.
> > >
> > > For testing this scenario it is enough to use just trial version of
> > > latest Windows Server from:
> > > https://go.microsoft.com/fwlink/p/?linkid=2208182
> > > https://go.microsoft.com/fwlink/p/?Linkid=2195280
> > >
> > > For setting NFS4.1 and SMB share named "test" I used these cmd commands:
> > >
> > >   dism /Online /Enable-Feature /All
> > > /FeatureName:ServerForNFS-Infrastructure
> > >   md C:\test
> > >   icacls C:\test /grant Everyone:(OI)(CI)F /T
> > >   nfsshare test=C:\test -o rw unmapped=yes
> > >   net share test=C:\test /grant:Everyone,FULL
> > >
> > > (for everyone who is going to reproduce this scenario, beware that new
> > > Windows servers use by default powershell, so first launch cmd.exe then
> > > copy+paste those commands)
> > >
> > > Pali
> > >
> > > On Saturday 14 September 2024 10:17:42 Pali Rohár wrote:
> > > > On Saturday 14 September 2024 01:21:17 Steve French wrote:
> > > > > On Fri, Sep 13, 2024 at 5:42 PM Pali Rohár <pali@kernel.org> wrote:
> > > > > >
> > > > > > On Friday 13 September 2024 17:14:22 Steve French wrote:
> > > > > > > How did you find the format of the FIFO and SOCK file types?  I
> > > > > >
> > > > > > For fifo there are multiple sources on internet, but none of them is
> > > > > > normative. Everything is just what people have tried. For example
> > > this
> > > > > > old email on samba list:
> > > > > >
> > > https://lists.samba.org/archive/linux-cifs-client/2005-May/000856.html
> > > > > >
> > > > > > Format of the socket I have figured out by creating it in Interix
> > > > > > subsystem and then dumped content of the file from Win32 subsystem.
> > > > > > Then I checked that it has also same format over older MS NFS server.
> > > > > > It was easier than trying to search for some documentation (which I
> > > have
> > > > > > not found).
> > > > > >
> > > > > > > couldn't find any references to those so added two new types to
> > > allow
> > > > > > > current Linux to be able to create these (especially since they are
> > > > > > > opaque to the server and thus low risk).
> > > > > >
> > > > > > I was searching over internet again and now I have found patent
> > > > > > https://patents.google.com/patent/US20090049459 which describe
> > > symlink
> > > > > > content:
> > > > > >
> > > > > > #define NFS_SPECFILE_LNK_V1 0x014b4e4c78746e49 /* “IntxLNK” */
> > > > > >
> > > > > > But does not describe other types.
> > > > > >
> > > > > > > > +     case S_IFSOCK:
> > > > > > > > -             strscpy(pdev.type, "LnxSOCK");
> > > > > > > > +             /* SFU socket is system file with one zero byte */
> > > > > > > > +             pdev_len = 1;
> > > > > > > > +             pdev.type[0] = '\0';
> > > > > > > >               break;
> > > > > > > >       case S_IFIFO:
> > > > > > > > -             strscpy(pdev.type, "LnxFIFO");
> > > > > > > > +             /* SFU fifo is system file which is empty */
> > > > > > > > +             pdev_len = 0;
> > > > > > >
> > > > > > > My worry about the suggested change above is that it is possible
> > > that
> > > > > > > we could accidentally match to an empty file.
> > > > > >
> > > > > > I fully understand your concerns, but code in this patch is for
> > > creating
> > > > > > new fifos. Not recognizing existing fifos.
> > > > > >
> > > > > > Code for recognizing existing fifos (=empty file with system
> > > attribute)
> > > > > > was not changed and is in Linux cifs client for a very long time.
> > > > > <>
> > > > > > > We intentionally added
> > > > > > > the two new dev.type fields for these to avoid collisions with
> > > other
> > > > > > > things (and since they are Linux specific).  It seems risky to
> > > have an
> > > > > > > empty file with the system attribute marked as a FIFO, and
> > > similarly a
> > > > > > > file with one byte null as Socket.   Since this is for only the
> > > Linux
> > > > > > > client to recognize, I wanted to do something safe for those file
> > > > > > > types less likely to be confusing (ie strings for Socket and FIFO
> > > that
> > > > > > > were similar in length and format to the other special files seemed
> > > > > > > intuitive) and "LnxFIFO" and LnxSOCK" were used as the tags in the
> > > > > > > file to reduce confusion ie the tags for those two start with
> > > "Lnx" -
> > > > > > > ie "something used for Linux client" not related to the original
> > > > > > > Interix (those begin with "Intx").
> > > > > >
> > > > > > I see. Now I understand what are those types (as I have not seen them
> > > > > > before). It is somehow misleading if such "LnxFIFO" and LnxSOCK"
> > > > > > functionality is provided by SFU option, but is incompatible with MS
> > > SFU
> > > > > > and also with MS NFS server. And is also incompatible with older
> > > Linux
> > > > > > cifs clients (as they do not understand those Lnx types).
> > > > >
> > > > > I am not as worried about FIFO and SOCK type being recognized by
> > > > > older servers (since almost every use case for them would be for them
> > > > > to be seen (only) by the client - e.g. for mounts to servers that
> > > > > don't implement reparse points yet), and since they are less
> > > > > common file types I am willing to let them be unrecognized by
> > > > > old clients (we can tag them for stable if older distros don't have
> > > > > them),
> > > >
> > > > This is quite pity for old clients, to break existing interoperability.
> > > > At least I see sfu as an compatibility option either for ecosystem with
> > > > old clients, or option where server itself does not support reparse
> > > > points.
> > > >
> > > > > but I am concerned about allowing "current clients" to
> > > > > create empty files for an unusual purpose which could be
> > > > > confusing/non-intuitive.
> > > >
> > > > I understand this concern. I thought that this should not be an issue
> > > > because files are created with system attribute which is not common for
> > > > normal/ordinary usage (system attribute could be less confusing) and
> > > > also because this format, at least for fifo is used and understood by
> > > > many SW for about 30 years.
> > > >
> > > > > And since this change (at least the one to allow FIFOs to be created
> > > with "sfu"
> > > > > has been in mainline for a year and also since it uses a more
> > > intuitive tag
> > > > > ("LnxFIFO") than the empty one used by very old Windows) the only
> > > > > clients who would have created these would be already using this newer
> > > tag
> > > > > (older Linux clients couldn't have created such files - there seems
> > > more
> > > > > risk of regression with reverting the change than with continuing with
> > > > > the Linux client specific tag (at least to the one for FIFOs
> > > > > since that has been in much longer than the socket one which is recent)
> > > >
> > > > This kind of stuff is lot of times used on LTS/stable linux
> > > > distributions and new kernel to these users/admins do not have to be
> > > > delivered yet. Mostly it takes 2-3 years after release. Look for example
> > > > at RHEL cycles.
> > > >
> > > > I'm looking on this from opposite perspective. I see this an regression
> > > > in -o sfu option that after upgrading from previous LTS version to new,
> > > > -o sfu stopped to be compatible with SFU-style fifos.
> > > >
> > > > But your point is valid. But maybe it is not an issue because users
> > > > do not have updated yet to new version?
> > > >
> > > > > Will discuss with others - opinions welcome.
> > > > >
> > > > > There is an upcoming SMB3.1.1 test event coming up next week (and the
> > > annual
> > > > > Storage Developer Conference too) so I can see if others have opinions
> > > one
> > > > > way or another on whether to move to empty (or 1 byte) files for
> > > > > creating fifos/sockets
> > > >
> > > > Ok, perfect, let me know then about the result.
> > > >
> > > > > > > Note that in the long run we hope to use reparse points by default
> > > in
> > > > > > > more servers to store special files like this but there are a few
> > > > > > > cases for unusual workloads that need special file support that
> > > would
> > > > > > > have to use sfu still.  The newer reparse tags that Windows uses
> > > "WSL"
> > > > > > > have the advantage that they require fewer roundtrips to query
> > > (since
> > > > > > > the file type is in the reparse tag).
> > > > > >
> > > > > > Yes, new WSL tags seems to be better. Also SFU mount option is not
> > > > > > activated by default.
> > > > > >
> > > > > > > Also noticed an interesting problem when mounted with "sfu" -
> > > > > > > "smbgetinfo filebasicinfo /mnt/fifo1" will hang (in sys_open).  Is
> > > > > > > that expected for a FIFO?
> > > > > >
> > > > > > Reading from fifo sleep reading process until some other process
> > > write
> > > > > > data to fifo. This is how fifos are working. You can try it on local
> > > > > > filesystem (e.g. ext4 or tmpfs).
> > > > >
> > > > > makes sense - thx
> > >
