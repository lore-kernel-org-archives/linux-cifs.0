From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: CIFS mount: 3.2.0-rc3 suspend crash
Date: Tue, 6 Dec 2011 20:57:20 -0600
Message-ID: <CAH2r5muxd786KGGscEGmTHTMbf9vjN-OPzwcHSNftf_vFWtNvg@mail.gmail.com>
References: <4ED56C12.1040708@gmail.com>
	<4ED5C047.6040500@linux.vnet.ibm.com>
	<20111130062502.68d9db59@tlielax.poochiereds.net>
	<201112062233.50317.rjw@sisk.pl>
	<20111206163810.24663e3f@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "Rafael J. Wysocki" <rjw-KKrjLPT3xs0@public.gmane.org>,
	"Srivatsa S. Bhat" <srivatsa.bhat-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>,
	Woody Suwalski <terraluna977-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Linux PM mailing list <linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
	Belisko Marek <marek.belisko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111206163810.24663e3f-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Dec 6, 2011 at 3:38 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Tue, 6 Dec 2011 22:33:50 +0100
> "Rafael J. Wysocki" <rjw-KKrjLPT3xs0@public.gmane.org> wrote:
>
>> On Wednesday, November 30, 2011, Jeff Layton wrote:
>> > On Wed, 30 Nov 2011 11:03:59 +0530
>> > "Srivatsa S. Bhat" <srivatsa.bhat-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org> wrote:
>>
>> [...]
>> >
>> > cifs: attempt to freeze while looping on a receive attempt
>> >
>> > In the recent overhaul of the demultiplex thread receive path, we
>> > neglected to ensure that we attempt to freeze on each pass through the
>> > loop.
>> >
>> > Reported-by: Woody Suwalski <terraluna977-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> > Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>
>> I suppose this patch is going to go through the CIFS tree?
>>
>
> Yes, Steve said he would push it Linus...

Yes.  I wanted to run a few general tests against the current cifs
tree first though.


-- 
Thanks,

Steve
