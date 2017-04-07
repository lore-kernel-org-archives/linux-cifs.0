From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [bug report] Handle mismatched open calls
Date: Thu, 6 Apr 2017 20:28:43 -0500
Message-ID: <CAH2r5murfUKpKZpFsZ9k7uPBtxc9QaBDUp_ht7NmHF=3geSHuA@mail.gmail.com>
References: <20170406091021.GA28584@mwanda> <1491473227.3042.2.camel@redhat.com>
 <1491503047.8010.2.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>,
        "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1491503047.8010.2.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

merged into cifs-2-6.git - let me know if you see any problems with these ASAP

On Thu, Apr 6, 2017 at 1:24 PM, Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Thu, 2017-04-06 at 11:07 +0100, Sachin Prabhu wrote:
>> On Thu, 2017-04-06 at 12:11 +0300, Dan Carpenter wrote:
>> > Hello Sachin Prabhu,
>> >
>> > The patch 96b75d0508f8: "Handle mismatched open calls" from Mar 3,
>> > 2017, leads to the following static checker warning:
>> >
>> >     fs/cifs/cifssmb.c:1530 cifs_readv_receive()
>> >     error: potential NULL dereference 'server->smallbuf'.
>> >
>> > fs/cifs/cifssmb.c
>> >   1519          cifs_dbg(FYI, "0: iov_base=%p iov_len=%u\n",
>> >   1520                   rdata->iov[0].iov_base, server-
>> > >total_read);
>> >   1521
>> >   1522          mid->resp_buf = server->smallbuf;
>> >   1523          server->smallbuf = NULL;
>> >                 ^^^^^^^^^^^^^^^^^^^^^^^
>> > We set this to NULL here
>> >
>> >   1524
>> >   1525          /* how much data is in the response? */
>> >   1526          data_len = server->ops->read_data_length(buf);
>> >   1527          if (data_offset + data_len > buflen) {
>> >   1528                  /* data_len is corrupt -- discard frame */
>> >   1529                  rdata->result = -EIO;
>> >   1530                  return cifs_readv_discard(server, mid);
>> >                                                   ^^^^^^
>> > but we need it here.
>> >
>> >   1531          }
>> >   1532
>> >   1533          length = rdata->read_into_pages(server, rdata,
>> > data_len);
>> >   1534          if (length < 0)
>> >   1535                  return length;
>> >
>> > regards,
>> > dan carpenter
>>
>> Thanks Dan,
>>
>
> Hello Dan,
>
> I have attached a patch which replaces the original
> "Handle mismatched open calls" patch from the for-next branch.
> Can you please run it against the static checker.
>
> In the patch, we pass a buffer to cifs_discard_remaining_data() instead
> of using server->small_buf to obtain the rfc len.
>
> Thanks
> Sachin Prabhu



-- 
Thanks,

Steve
