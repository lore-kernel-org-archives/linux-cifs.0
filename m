From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [cifs:for-next 50/71] fs/cifs/file.c:3157:23-27: ERROR: invalid
 reference to the index variable of the iterator on line 3149
Date: Wed, 19 Sep 2012 14:42:24 -0500
Message-ID: <CAH2r5mu-COxnqnNhp_FH2Y7Pu3R1-S5Tj0v8hKwV72McyydpeA@mail.gmail.com>
References: <20120919050802.GA28801@localhost>
	<20120919062508.70ba65eb@corrin.poochiereds.net>
	<20120919110518.05b707e5@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Fengguang Wu <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
	kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120919110518.05b707e5-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I repulled jeff's cifs-next into my fcifs-2.6. for-next.  Added the
fixes from Pavel (SMB2 endian fix, and memory leak) and the fix to
allow us to negotiate "vers=3.0" - am rebuilding now but expect it do
continue to do ok for simple smb2.1 and smb3.0 functional testing
(sans signing) - with the known problem of lack of symlinks and rename
of open files and cifsacl (chmod)

On Wed, Sep 19, 2012 at 1:05 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Wed, 19 Sep 2012 06:25:08 -0700
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
>> On Wed, 19 Sep 2012 13:08:02 +0800
>> Fengguang Wu <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>>
>> > Hi Jeff,
>> >
>> > FYI, there are new coccinelle warnings show up in
>> >
>> > tree:   git://git.samba.org/sfrench/cifs-2.6.git for-next
>> > head:   324b53bbcd1d9795062f00e92064296169c9b081
>> > commit: a4a23914d0d1736eb6d98049d303d551131df83c [50/71] cifs: turn the pages list in cifs_readdata into an array
>> >
>> > All coccinelle warnings:
>> >
>> > + fs/cifs/file.c:3157:23-27: ERROR: invalid reference to the index variable of the iterator on line 3149
>> >
>> > vim +3157 fs/cifs/file.c
>> >   3147                      rdata->marshal_iov = cifs_readpages_marshal_iov;
>> >   3148
>> > > 3149                      list_for_each_entry_safe(page, tpage, &tmplist, lru) {
>> >   3150                              list_del(&page->lru);
>> >   3151                              rdata->pages[rdata->nr_pages++] = page;
>> >   3152                      }
>> >   3153
>> >   3154                      rc = cifs_retry_async_readv(rdata);
>> >   3155                      if (rc != 0) {
>> >   3156                              for (i = 0; i < rdata->nr_pages; i++) {
>> > > 3157                                      lru_cache_add_file(page);
>> >   3158                                      unlock_page(page);
>> >   3159                                      page_cache_release(page);
>> >   3160                              }
>> >   3161                              kref_put(&rdata->refcount, cifs_readdata_release);
>> >   3162                              break;
>> >   3163                      }
>> >   3164
>> >   3165                      kref_put(&rdata->refcount, cifs_readdata_release);
>> >   3166              }
>> >   3167
>> >
>> > ---
>> > 0-DAY kernel build testing backend         Open Source Technology Centre
>> > Fengguang Wu, Yuanhan Liu                              Intel Corporation
>>
>>
>> Thanks Wu, good catch. I've got a fix that I'll push to Steve today.
>>
>
> FWIW, here's the (trivial) patch to fix this. Steve, I've respun the
> patch that introduced this bug and pushed it out to my cifs-next
> branch. This should be the only difference.
>
> You If you'd rather do a patch on top of your tree instead, let me
> know...
>
> ---------------------------[snip]-----------------------------
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 1d43303..075f7cf 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -3280,6 +3280,7 @@ static int cifs_readpages(struct file *file, struct address_space *mapping,
>                 rc = cifs_retry_async_readv(rdata);
>                 if (rc != 0) {
>                         for (i = 0; i < rdata->nr_pages; i++) {
> +                               page = rdata->pages[i];
>                                 lru_cache_add_file(page);
>                                 unlock_page(page);
>                                 page_cache_release(page);



-- 
Thanks,

Steve
