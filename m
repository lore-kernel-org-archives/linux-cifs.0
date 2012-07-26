From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [GIT] CIFS Fixes
Date: Thu, 26 Jul 2012 16:38:44 -0500
Message-ID: <CAH2r5mtt4_EmSfEVjauixdrEoXPAy26FwTKk2Q-fDvRDuAeR-w@mail.gmail.com>
References: <CAH2r5mvgQTG2j68c78hiZBMbgNvL3t6iY+d6CWnvtqQXNu2kaw@mail.gmail.com>
	<CA+55aFwNMt9BAvVdkzJTwo6J2r+-kwTH+VeO3ihx8L2wyAYeLg@mail.gmail.com>
	<CAH2r5mtuuGdP6q6FHkJDtszVViUg8_nqJsdRT9=rN-eP4fLisw@mail.gmail.com>
	<CA+55aFzykb86LJKP+gsHM=9wqfyChB=N7cNsCGi-BpQSB_OSOA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+55aFzykb86LJKP+gsHM=9wqfyChB=N7cNsCGi-BpQSB_OSOA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

OK - understood.  The description I was about to send you was:

CIFS/SMB2 changes for first part of merge window:

The largest part of the changes includes new error mappings for NT Status
codes to map directly to posix errors (needed for SMB2)

This set also include the following changes:
1) async write cleanup
2) move protocol specific mount/stat code to ops structure
3) add SMB2 protocol support for mount/stat
Additional SMB2 is nearing review completion.
4) assorted cifs fixes from Jeff



On Thu, Jul 26, 2012 at 4:32 PM, Linus Torvalds
<torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
> On Thu, Jul 26, 2012 at 2:30 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>
>> Yes - will resent merge request with additional description.
>
> I ended up merging it, but for future pull requests please do add
> summary information so that the merge commits can have relevant
> descriptions of what the merge actually does.
>
>             Linus



-- 
Thanks,

Steve
