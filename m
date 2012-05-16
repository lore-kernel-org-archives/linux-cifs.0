From: Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>
Subject: Re: SLUB cifs_request: kmem_cache_destroy called for cache that still
 has objects.
Date: Wed, 16 May 2012 11:41:39 +0530
Message-ID: <4FB3451B.5020704@suse.com>
References: <20120515204642.1a5bedee@corrin.poochiereds.net> <CAH2r5muoDPbWv5jpK7hkyVAV_EOGoAVUccz86nZsxPy6WyahpQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5muoDPbWv5jpK7hkyVAV_EOGoAVUccz86nZsxPy6WyahpQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 05/16/2012 09:30 AM, Steve French wrote:
> I don't see that on my rc7 system and I have slub debugging and
> various other debugging options on in my rc7 config.  Let me know if
> you find a way to reproduce it or want me to try with your config.
> 
> On Tue, May 15, 2012 at 7:46 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>> I saw this today when unplugging cifs.ko in a stock -rc7 kernel. I
>> never mounted any cifs mounts, so this is entirely due to module
>> initialization as far as I can tell:
>>
>> [  464.776843] SLUB cifs_request: kmem_cache_destroy called for cache that still has objects.
>> [  464.779071] Pid: 4738, comm: rmmod Not tainted 3.4.0-0.rc7.git0.1.fc18.x86_64 #1
>> [  464.780243] Call Trace:
>> [  464.780433]  [<ffffffff8116b53a>] kmem_cache_destroy+0x2ba/0x360
>> [  464.780870]  [<ffffffffa00d6469>] cifs_destroy_request_bufs+0x21/0x3b [cifs]
>> [  464.781397]  [<ffffffffa00d66a6>] exit_cifs+0x30/0x98a [cifs]
>> [  464.781944]  [<ffffffff810b4a3e>] sys_delete_module+0x16e/0x2d0
>> [  464.782482]  [<ffffffff8117c186>] ? filp_close+0x66/0xa0
>> [  464.782903]  [<ffffffff81603769>] system_call_fastpath+0x16/0x1b
>>
>> ...any ideas?

Sounds to me like a slub problem affecting random modules that could be
fixed by this patch

  http://comments.gmane.org/gmane.linux.kernel.mm/78106

If you are able to reliably reproduce, it is worth giving the patch a
shot. But, I could be totally wrong too...


Suresh
