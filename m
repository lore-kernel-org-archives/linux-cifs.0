From: Leif Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 01/19] cifs: Add smb2_send_recv
Date: Mon, 20 Nov 2017 17:54:35 -0500 (EST)
Message-ID: <1674281245.28781767.1511218475801.JavaMail.zimbra@redhat.com>
References: <20171120002447.32322-1-lsahlber@redhat.com> <20171120002447.32322-2-lsahlber@redhat.com> <CAKywueSFic+_oPy9tw7WAWLtP9v2H19cy6kpsieT7cD2w=CVuw@mail.gmail.com> <CAKywueQWAnWW=kzbZWbGBgzT+HjiTQC6SXdh-ixrZacY-+_Omw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueQWAnWW=kzbZWbGBgzT+HjiTQC6SXdh-ixrZacY-+_Omw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

That is a good idea.

I can update both functions to do that once the current "remove 1002 from request" 
lands.


----- Original Message -----
From: "Pavel Shilovsky" <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: "Ronnie Sahlberg" <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-cifs" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Steve French" <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Aurélien Aptel" <aaptel-IBi9RG/b67k@public.gmane.org>
Sent: Tuesday, 21 November, 2017 8:52:46 AM
Subject: Re: [PATCH 01/19] cifs: Add smb2_send_recv

2017-11-20 13:50 GMT-08:00 Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> 2017-11-19 16:24 GMT-08:00 Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
>> This function is similar to SendReceive2 except it does not expect
>> a 4 byte rfc1002 length header in the first io vector.
>>
>> Signed-off-by: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> ---
>>  fs/cifs/cifsproto.h |  4 ++++
>>  fs/cifs/transport.c | 38 ++++++++++++++++++++++++++++++++++++++
>>  2 files changed, 42 insertions(+)
>>
>> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
>> index 4143c9dec463..6d86cd120349 100644
>> --- a/fs/cifs/cifsproto.h
>> +++ b/fs/cifs/cifsproto.h
>> @@ -106,6 +106,10 @@ extern int SendReceive2(const unsigned int /* xid */ , struct cifs_ses *,
>>                         struct kvec *, int /* nvec to send */,
>>                         int * /* type of buf returned */, const int flags,
>>                         struct kvec * /* resp vec */);
>> +extern int smb2_send_recv(const unsigned int /* xid */ , struct cifs_ses *,
>> +                         struct kvec *, int /* nvec to send */,
>> +                         int * /* type of buf returned */, const int flags,
>> +                         struct kvec * /* resp vec */);
>>  extern int SendReceiveBlockingLock(const unsigned int xid,
>>                         struct cifs_tcon *ptcon,
>>                         struct smb_hdr *in_buf ,
>> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
>> index 7efbab013957..e678307bb7a0 100644
>> --- a/fs/cifs/transport.c
>> +++ b/fs/cifs/transport.c
>> @@ -827,6 +827,44 @@ SendReceive2(const unsigned int xid, struct cifs_ses *ses,
>>         return rc;
>>  }
>>
>> +/* Like SendReceive2 but iov[0] does not contain an rfc1002 header */
>> +int
>> +smb2_send_recv(const unsigned int xid, struct cifs_ses *ses,
>> +              struct kvec *iov, int n_vec, int *resp_buf_type /* ret */,
>> +              const int flags, struct kvec *resp_iov)
>> +{
>> +       struct smb_rqst rqst;
>> +       struct kvec *new_iov;
>> +       int rc;
>> +       int i;
>> +       __u32 count;
>> +       __be32 rfc1002_marker;
>> +
>> +       new_iov = kmalloc(sizeof(struct kvec) * (n_vec + 1), GFP_KERNEL);
>> +       if (!new_iov)
>> +               return -ENOMEM;
>
> Probably it is out of the scope of this patchset but can we do a
> simple hack here: allocate a fixed size array on stack (suppose iov[8]
> which is more that enough for most cases) and use dynamic allocation
> only if n_vec + 1 is greater than this fixed value? I can use the same

         ^^^
I == We. Sorry - typo.

> approach in SendReceive2() as well.
