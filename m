From: "Christopher R. Hertel" <crh-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH 06/11] CIFS: Respect MaxMpxCount field
Date: Fri, 09 Mar 2012 15:05:39 -0600
Message-ID: <4F5A70A3.906@samba.org>
References: <1329895984-9251-1-git-send-email-piastry@etersoft.ru> <1329895984-9251-7-git-send-email-piastry@etersoft.ru> <CAH2r5mvVToaHozN3=YgCCCWFFnjE9AP5xX_BF2JdxDj_JvKsbQ@mail.gmail.com> <CAKywueRwzdak2LfpfVkiX2ue0A-0a15J9kO8kgUYseRPXM8Tfw@mail.gmail.com> <20120303070921.5ce2bb10@tlielax.poochiereds.net> <CAH2r5mvGjzS73bhgG54Yzcqui9qxfv7e3yrxWZX+weSUQB4cHA@mail.gmail.com> <20120309073930.3a79fa10@redhat.com> <CAH2r5mvzgnTcyhL-Rip9yHUEMsLOCFhfAoNdRyVqhNFin_A6mw@mail.gmail.com> <4F5A543D.2040808@samba.org> <20120309201439.GH9348@samba2>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120309201439.GH9348@samba2>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 03/09/2012 02:14 PM, Jeremy Allison wrote:
> On Fri, Mar 09, 2012 at 01:04:29PM -0600, Christopher R. Hertel wrote:
>>
>> The folks at Microsoft (who are, of course, well ahead in their
>> SMB2.x implementations) are very surprised that we are trying to
>> maintain a single codebase for both protocols.  (I heard the same
>> thing from several Microsoft engineers during separate
>> conversations.)
>
> That's just a misunderstanding of how our codebase is
> structured, that's all.
>
> The SMB1 parser/protocol engine is completely different code from the SMB2
> parser/protocol engine in Samba.

I was thinking of the CIFS client, which is what Jeff was talking about.

> What is in common (as is also in common in Microsoft's codebase)
> is the code that implements the underlying file system functionality.

Having seen the code, I'd say it's mixed.  There is actually a lot of work 
done in the server system to massage and validate the requests before 
converting them into NT system requests and passing them down.

I was surprised by that at first.  I expected it for the DOS and OS/2 calls. 
  Semantics for those needed to be converted to NT semantics, which made 
sense.  What surprised me was how much work was done on SMB_COM_NT_* commands.

Looking more closely, I found that some of the work done on NT-to-NT calls 
was done to ensure that the DOS and OS/2 state were kept up to date.  There 
was other work done, however.  It's not a simple pass-through.  In part 
because the SMB server has to defend the kernel from bogus calls and values.

The SMB2 server code does not need to worry about DOS and OS/2 semantics, 
but there are a number of new features and behaviors it does need to handle. 
  So, the SMB2 code processes requests differently.

> They have a common NTFS (and now ReFS) codebase, we have a common
> map POSIX to Windows semantics layer.

...and at that level I agree.  That layer can be a single layer accessed by 
both protocols.

Keep in mind, though, that SMB1 is dead and will never make use of things 
like durable, resilient, and persistent handles.  It will also never fully 
expose the semantics of ReFS.  Similarly, SMB2 will never need to worry 
about presenting DOS and OS/2 as SMB1 does.

So some of the semantics that file system mapping layer has to handle are 
going to be purely for one protocol or the other.  The biggest part of the 
overlap there will be NTFS semantics... which is, admittedly, the lions 
share of the market now and for some time to come.

Chris -)-----

-- 
"Implementing CIFS - the Common Internet FileSystem" ISBN: 013047116X
Samba Team -- http://www.samba.org/     -)-----   Christopher R. Hertel
jCIFS Team -- http://jcifs.samba.org/   -)-----   ubiqx development, uninq.
ubiqx Team -- http://www.ubiqx.org/     -)-----   crh-jFlgvBokg3lg9hUCZPvPmw@public.gmane.org
OnLineBook -- http://ubiqx.org/cifs/    -)-----   crh-zuGDro9SezXYtjvyW6yDsg@public.gmane.org
