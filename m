From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: show 'soft' in the mount options for !hard mounts
Date: Tue, 19 Sep 2017 22:25:52 -0500
Message-ID: <CAH2r5mtW38uGGO5LPKyy=O8mzctgq0kLAWbBadzk+0ztvF6Org@mail.gmail.com>
References: <20170920030923.23453-1-lsahlber@redhat.com> <CAH2r5msLbzwzFvwosLpLJLeLNu4+3EEs=UTxZoOzyXeOWX6mjQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5msLbzwzFvwosLpLJLeLNu4+3EEs=UTxZoOzyXeOWX6mjQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

What does NFS do - does it show both "soft" and "hard"?

On Tue, Sep 19, 2017 at 10:22 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Opinions on stable?
>
> On Sep 19, 2017 8:09 PM, "Ronnie Sahlberg" <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>>
>> Signed-off-by: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> ---
>>  fs/cifs/cifsfs.c | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
>> index 180b3356ff86..a864e6575309 100644
>> --- a/fs/cifs/cifsfs.c
>> +++ b/fs/cifs/cifsfs.c
>> @@ -461,6 +461,8 @@ cifs_show_options(struct seq_file *s, struct dentry
>> *root)
>>                 seq_puts(s, ",nocase");
>>         if (tcon->retry)
>>                 seq_puts(s, ",hard");
>> +       else
>> +               seq_puts(s, ",soft");
>>         if (tcon->use_persistent)
>>                 seq_puts(s, ",persistenthandles");
>>         else if (tcon->use_resilient)
>> --
>> 2.13.3
>>
>



-- 
Thanks,

Steve
