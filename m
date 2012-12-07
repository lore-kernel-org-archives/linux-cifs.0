From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/3] Add O_DENY* flags to fcntl and cifs
Date: Fri, 7 Dec 2012 08:29:39 -0600
Message-ID: <CAH2r5msoPiu7wz-HjnnqTxeBLVEQiMYSnLMaZ+dEr11j6Fo4Ew@mail.gmail.com>
References: <1354818391-7968-1-git-send-email-piastry@etersoft.ru>
	<20121206194949.7ab20d56@pyramind.ukuu.org.uk>
	<20121206195752.GA18585@samba2>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>,
	Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, wine-devel-5vRYHf7vrtgdnm+yROfE0A@public.gmane.org,
	linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121206195752.GA18585@samba2>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Dec 6, 2012 at 1:57 PM, Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> On Thu, Dec 06, 2012 at 07:49:49PM +0000, Alan Cox wrote:
>> On Thu,  6 Dec 2012 22:26:28 +0400
>> Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
>>
>> > Network filesystems CIFS, SMB2.0, SMB3.0 and NFSv4 have such flags - this change can benefit cifs and nfs modules. While this change is ok for network filesystems, itsn't not targeted for local filesystems due security problems (e.g. when a user process can deny root to delete a file).
>>
>> If I have my root fs on NFS then the same applies does it not.
>>
>> Your patches fail to describe the security semantics and what file rights
>> I must have to apply each option. How do I track down a lock user, what
>> tools are provided ? How do the new options interact with the security
>> layer?
>>
>> I don't have a problem with the idea, but it needs a lot more clear
>> description of how it works so the model can be checked and if need be
>> things tweaked (eg needing write to denywrite etc)
>
> And this is where things get really ugly of course :-).
>
> For the CIFSFS client they're expecting to be able to
> just ship them to a Windows server, where they'll
> get the (insane) Windows semantics. These semantics
> are not what would be wanted on a local filesystem.
>
> So unless we just say "these things have Windows
> semantics" (where openers of files can lock out others

I suspect that WINE would have the same need
to ship them to an NFS server as to a Windows server,
and the NFS4 protocol specification also defines these,
although I could not find the same level of detail that MS-FSA
provides (e.g. see section 2.14.10 for the detailed
description of how lock conflicts are checked) but the
semantics are probably the same.

-- 
Thanks,

Steve
