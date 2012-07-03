From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: 3.5.0-rc3 (approximately) oops on cifs mount
Date: Tue, 3 Jul 2012 12:37:44 -0700
Message-ID: <CALCETrVLG5y6B-DWHX_5pOMifxq562VM9LYVgpNNa5qoEKUhHg@mail.gmail.com>
References: <CALCETrVOwRyrBXDu0G=JE3dtwmXFNV6dAEHVPXYoJfUf6s2==w@mail.gmail.com>
 <CAH2r5muEUANOjGCkP40LfFF3XtkKKtf9RAabzt-1H+xn1v5ccg@mail.gmail.com>
 <CALCETrWnXh9cDMzF2=yo7XqvgmPGeSPQ+uXYkniVXP4PuRoQCw@mail.gmail.com>
 <CALCETrV=7DrqzNBLBdUVycM8471+vfA5H3Hf7-PTjanH0K8=gg@mail.gmail.com> <20120703152203.065838cb@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Steve French <smfrench@gmail.com>, linux-kernel@vger.kernel.org,
	linux-cifs@vger.kernel.org
To: Jeff Layton <jlayton@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120703152203.065838cb@tlielax.poochiereds.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Tue, Jul 3, 2012 at 12:22 PM, Jeff Layton <jlayton@redhat.com> wrote:
> On Tue, 3 Jul 2012 11:59:02 -0700
> Andy Lutomirski <luto@amacapital.net> wrote:
>
>> On Mon, Jul 2, 2012 at 5:28 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>> > On Mon, Jul 2, 2012 at 5:21 PM, Steve French <smfrench@gmail.com> wrote:
>> >> Any recreation information?
>> >
>> > I think it was a result of trying to mount with an incorrect password,
>> > which surprises me a bit.  I'll try to reproduce in a little bit.
>>
>> Correction: it was not a wrong password -- I mounted with the correct
>> password.  So far, I can't reproduce it.
>>
>> --Andy
>>
>
> It crashed here:
>
>     BUG_ON(cpu >= nr_cpu_ids && cpu != WORK_CPU_UNBOUND);
>
> Very odd. Seems almost like this must be some sort of memory
> corruption. The work is initialized just a little bit before it gets
> queued. The only thing I can figure is that something raced in and
> clobbered the work struct beforehand.
>
> One thing you could do -- maybe disassemble get_work_gcwq() and post
> the results here? Maybe from that we can see what the "cpu" value
> actually was by figuring out the register that holds it?

I'll see if I can find an identical kernel build.  Unfortunately, I
hit this oops after building and installing a new kernel but before
rebooting into it.

--Andy

>
> --
> Jeff Layton <jlayton@redhat.com>



-- 
Andy Lutomirski
AMA Capital Management, LLC
