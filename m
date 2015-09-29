From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: strange bottleneck with SMB 2.0
Date: Mon, 28 Sep 2015 19:18:13 -0500
Message-ID: <CAH2r5mvig6xeBrFVYc51eC4FOrQuC8Bxn2iC8L+h0T6odeLy8A@mail.gmail.com>
References: <CALQF7Zw5ET+uhgskMDMar31q1uo98nkSd9dusX4gQpS47-zKig@mail.gmail.com>
 <20150820085701.46611da1@tlielax.poochiereds.net> <CALQF7Zz63RFF6C4YW8C0-spwHju=BTCDcyKtvAUh_0Lhe=Xseg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Yale Zhang <yzhang1985-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALQF7Zz63RFF6C4YW8C0-spwHju=BTCDcyKtvAUh_0Lhe=Xseg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The good news is that we really, really don't want to encourage SMB2.0
(SMB2.1 and later have better performance and security) and we want to
encourage SMB3.0 (SMB3.02 is fine too, but SMB3.11 is still
experimental) so we want users to mount with "vers=3.0" except to
Samba (where Unix Extensions to CIFS make it an interesting tradeoff
which is better "vers=3.0" or cifs with unix extensions).

Perhaps the odd behavior difference has to do with the lack of
multicredit/large read/large write support in SMB2.  Note rsize/wsize
is only 64K in SMB2 as a result - and SMB2.1 and later get 1MB
read/write sizes which is better.

On Mon, Sep 28, 2015 at 7:09 PM, Yale Zhang <yzhang1985-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Sorry about the delay. I haven't been spending time on this issue
> because I can just use SMB 3. But for anyone else who is stuck, here's
> my diagnosis:
>
> I also found that the 2nd & 3rd instances of a.out doesn't always need
> to wait for the 1st one to finish before starting. They consistently
> start 35.5s after the 1st one.
>
> Here are my observations after the 1st program launches and the 2nd &
> 3rd are prevented from starting:
>
> 1. the 1st a.out is in the running state R+
> 2. the 2nd a.out still hasn't started. Bash has forked itself to call
> exec("a.out"), but ps still shows the forked process as Bash, not
> a.out. The process is in the D+ state, meaning it's inside the kernel.
> I tried getting the kernel stack trace as Jeff suggested, but "cat
> /proc/3718/stack" hangs!
> Eventually when a.out starts 35.5s after the 1st one, I see this:
>
> [<ffffffff81113a35>] __alloc_pages_nodemask+0x1a5/0x990
> [<ffffffff811b9aaa>] load_elf_binary+0xda/0xeb0
> [<ffffffff811375a2>] __vma_link_rb+0x62/0xb0
> [<ffffffff81150cb8>] alloc_pages_vma+0x158/0x210
> [<ffffffff813623e5>] cpumask_any_but+0x25/0x40
> [<ffffffff8104c8a2>] flush_tlb_page+0x32/0x90
> [<ffffffff8113c932>] page_add_new_anon_rmap+0x72/0xe0
> [<ffffffff8112ffbf>] wp_page_copy+0x31f/0x450
> [<ffffffff81159885>] cache_alloc_refill+0x85/0x340
> [<ffffffff8115a06f>] kmem_cache_alloc+0x14f/0x1b0
> [<ffffffff81070dc0>] prepare_creds+0x20/0xd0
> [<ffffffff81167f45>] SyS_faccessat+0x65/0x270
> [<ffffffff81045f23>] __do_page_fault+0x253/0x4c0
> [<ffffffff817558d7>] system_call_fastpath+0x12/0x6a
> [<ffffffffffffffff>] 0xffffffffffffffff
>
> But that trace is probably irrelevant, because it's now in the running state.
>
> Absolutely bizarre. And appalling since it's like you're hurt and
> can't even yell for help (view the kernel stack)
>
>
>
> On Thu, Aug 20, 2015 at 5:57 AM, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org> wrote:
>> On Wed, 19 Aug 2015 04:11:31 -0700
>> Yale Zhang <yzhang1985-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>
>>> SMB developers/users,
>>>
>>> I'm experiencing a strange bottleneck when my files are mounted as SMB
>>> 2.0. When I launch  multiple processes in parallel for benchmarking,
>>> only the 1st one starts, and the rest won't start until the 1st one
>>> finishes:
>>>
>>> ---------------------------------------test
>>> programs--------------------------------
>>> #!/bin/sh
>>> ./a.out&
>>> ./a.out&
>>> ./a.out&
>>> wait
>>>
>>> a.out is just a C program like this:
>>>
>>> int main()
>>> {
>>>   printf("greetings\n");
>>>   while (true);
>>>   return 0;
>>> }
>>>
>>> Apparently, this only affects SMB 2.0. I tried it with SMB 2.1, SMB
>>> 3.0, & SMB 3.02, and everything starts in parallel as expected.
>>>
>>> I'm assuming SMB 3 and especially SMB 2.1 would share a common
>>> implementation. How could 2.0 have the problem but not 3? It almost
>>> seems the bottleneck is a feature instead of a bug?  8(
>>>
>>> Can it still be fixed?
>>>
>>> -Yale
>>
>> Probably. It'd be interesting to see what the other tasks are blocking
>> on. After firing up the second one can you run:
>>
>>     # cat /proc/<pid of second a.out>/stack
>>
>> ...and paste the stack trace here? That should tell us what those other
>> processes are doing.
>>
>> --
>> Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,

Steve
