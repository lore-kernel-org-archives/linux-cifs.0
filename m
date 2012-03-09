From: "Christopher R. Hertel" <crh-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH 06/11] CIFS: Respect MaxMpxCount field
Date: Fri, 09 Mar 2012 15:07:56 -0600
Message-ID: <4F5A712C.8030500@samba.org>
References: <1329895984-9251-1-git-send-email-piastry@etersoft.ru> <1329895984-9251-7-git-send-email-piastry@etersoft.ru> <CAH2r5mvVToaHozN3=YgCCCWFFnjE9AP5xX_BF2JdxDj_JvKsbQ@mail.gmail.com> <CAKywueRwzdak2LfpfVkiX2ue0A-0a15J9kO8kgUYseRPXM8Tfw@mail.gmail.com> <20120303070921.5ce2bb10@tlielax.poochiereds.net> <CAH2r5mvGjzS73bhgG54Yzcqui9qxfv7e3yrxWZX+weSUQB4cHA@mail.gmail.com> <20120309073930.3a79fa10@redhat.com> <CAH2r5mvzgnTcyhL-Rip9yHUEMsLOCFhfAoNdRyVqhNFin_A6mw@mail.gmail.com> <4F5A543D.2040808@samba.org> <20120309201439.GH9348@samba2> <CAH2r5mvMWOVrKXYJjcKYwUR+yaJpzYysDoc+TvPmfN+RDHAQ5g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mvMWOVrKXYJjcKYwUR+yaJpzYysDoc+TvPmfN+RDHAQ5g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 03/09/2012 02:16 PM, Steve French wrote:
> On Fri, Mar 9, 2012 at 2:14 PM, Jeremy Allison<jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>  wrote:
>> On Fri, Mar 09, 2012 at 01:04:29PM -0600, Christopher R. Hertel wrote:
>>>
>>> The folks at Microsoft (who are, of course, well ahead in their
>>> SMB2.x implementations) are very surprised that we are trying to
>>> maintain a single codebase for both protocols.  (I heard the same
>>> thing from several Microsoft engineers during separate
>>> conversations.)
>>
>> That's just a misunderstanding of how our codebase is
>> structured, that's all.
>>
>> The SMB1 parser/protocol engine is completely different code from the SMB2
>> parser/protocol engine in Samba.
>>
>> What is in common (as is also in common in Microsoft's codebase)
>> is the code that implements the underlying file system functionality.
>>
>> They have a common NTFS (and now ReFS) codebase, we have a common
>> map POSIX to Windows semantics layer.
>
> On the client side, as a compromise with those who wanted one module,
> (ie in Pavel's tree) we keep the majority of the smb2 specific code in
> distinct c files
> which are not linked in by default to cifs.ko.   Sharing the same transport code
> does have headaches though as the discussion above mentions with regard
> to "credits" vs. "maxmpx" but it has turned out better than I originally
> expected (ie the changes to common code)

No doubt.

...and we certainly want only one piece of code actually creating and 
managing connections to the server.

-- 
"Implementing CIFS - the Common Internet FileSystem" ISBN: 013047116X
Samba Team -- http://www.samba.org/     -)-----   Christopher R. Hertel
jCIFS Team -- http://jcifs.samba.org/   -)-----   ubiqx development, uninq.
ubiqx Team -- http://www.ubiqx.org/     -)-----   crh-jFlgvBokg3lg9hUCZPvPmw@public.gmane.org
OnLineBook -- http://ubiqx.org/cifs/    -)-----   crh-zuGDro9SezXYtjvyW6yDsg@public.gmane.org
