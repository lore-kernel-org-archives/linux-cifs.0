From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [bug report] CIFS: Implement follow_link for SMB2
Date: Sun, 24 Jul 2016 10:40:52 +0300
Message-ID: <CAKywueTVAk0G=YW8A+ykXS5RfydPooWU+aP-Xsw5gG6+zhaRQQ@mail.gmail.com>
References: <20160712135507.GA30732@mwanda> <CAKywueR7pGqL-HqqJH60XxPJ8fr1Mf3H7BZsSp2ePfXkdvH5sQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueR7pGqL-HqqJH60XxPJ8fr1Mf3H7BZsSp2ePfXkdvH5sQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2016-07-19 22:27 GMT+03:00 Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:
> 2016-07-12 16:55 GMT+03:00 Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>:
>> Hello Pavel Shilovsky,
>>
>> The patch b42bf88828cd: "CIFS: Implement follow_link for SMB2" from
>> Aug 14, 2013, leads to the following static checker warning:
>>
>>         fs/cifs/smb2pdu.c:1408 SMB2_open()
>>         warn: potentially allocating too little.  77 vs 4
>>
>> fs/cifs/smb2pdu.c
>>   1402          rc = SendReceive2(xid, ses, iov, num_iovecs, &resp_buftype, 0);
>>   1403          rsp = (struct smb2_create_rsp *)iov[0].iov_base;
>>   1404
>>   1405          if (rc != 0) {
>>   1406                  cifs_stats_fail_inc(tcon, SMB2_CREATE_HE);
>>   1407                  if (err_buf)
>>   1408                          *err_buf = kmemdup(rsp, get_rfc1002_length(rsp) + 4,
>>
>> I'm not an expert, but these look like it might be controlled from user
>> space.  How do we know that get_rfc1002_length() returns something large
>> enough?
>
> Good catch. err_buf is used by smb2_query_symlink() without any checks
> for a buffer size. Thanks!
>
> --
> Best regards,
> Pavel Shilovsky

I have posted a patch "CIFS: Fix a possible invalid memory access in
smb2_query_symlink()" that addressed the problem. It seems like we
good in SMB2_open() but an invalid memory access can happen in
smb2_query_symlink().

-- 
Best regards,
Pavel Shilovsky
