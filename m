From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: WARN_ON_ONCE if kernel_sendmsg() returns -ENOSPC
Date: Wed, 3 Oct 2012 14:16:01 -0500
Message-ID: <CAH2r5mvcHw58GnVkJYZRB_w4fsrQSRgUhKpSxVpEDOLT+v8T1w@mail.gmail.com>
References: <506C6058.6060008@suse.com>
	<20121003122417.51c52f31@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121003122417.51c52f31-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

merged into cifs-2.6.git

On Wed, Oct 3, 2012 at 11:24 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Wed, 03 Oct 2012 21:27:12 +0530
> Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org> wrote:
>
>> kernel_sendmsg() is less likely to return -ENOSPC and it might be
>> a bug to do so. However, in the past there might have been cases
>> where a -ENOSPC was returned from a low level driver.
>>
>> Add a WARN_ON_ONCE() to ensure that it is safe to assume that -ENOSPC
>> is no longer returned. This -ENOSPC specific handling will be removed
>> once we are sure it is no longer returned.
>>
>>
>> Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> Signed-off-by: Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>
>> ---
>>
>>  fs/cifs/transport.c |    6 ++++++
>>  1 file changed, 6 insertions(+)
>>
>> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
>> index d9b639b..c613fca 100644
>> --- a/fs/cifs/transport.c
>> +++ b/fs/cifs/transport.c
>> @@ -155,6 +155,12 @@ smb_sendv(struct TCP_Server_Info *server, struct kvec *iov, int n_vec)
>>               rc = kernel_sendmsg(ssocket, &smb_msg, &iov[first_vec],
>>                                   n_vec - first_vec, total_len);
>>               if ((rc == -ENOSPC) || (rc == -EAGAIN)) {
>> +                     /*
>> +                      * Catch if a low level driver returns -ENOSPC. This
>> +                      * WARN_ON will be removed by 3.10 if no one reports
>> +                      * seeing this.
>> +                      */
>> +                     WARN_ON_ONCE(rc == -ENOSPC);
>>                       i++;
>>                       /*
>>                        * If blocking send we try 3 times, since each can block
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> LGTM
>
> Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>



-- 
Thanks,

Steve
