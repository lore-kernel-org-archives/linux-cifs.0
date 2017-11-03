From: ronnie sahlberg <ronniesahlberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 01/19] cifs: Add SendReceive3
Date: Fri, 3 Nov 2017 16:37:59 +1000
Message-ID: <CAN05THS8m9Z=KwiGarKh4qJT-X_ZnYU_AqVe26NNtF3Ad9j5nQ@mail.gmail.com>
References: <20171102070312.18903-1-lsahlber@redhat.com> <20171102070312.18903-2-lsahlber@redhat.com>
 <20171103062715.GB8075@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
        linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171103062715.GB8075-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Nov 3, 2017 at 4:27 PM, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
> On Thu, Nov 02, 2017 at 06:02:54PM +1100, Ronnie Sahlberg wrote:
>> This function is similar to SendReceive2 except it does not expect
>> a 4 byte rfc1002 length header in the first io vector.
>
> Can you give it a proper name?  cifs_ prefix, lower case with _
> as the word delimiter.

Since this will now be the _only_ send/receive function SMB2 uses
(except for the two async calls)
I can rename it s/SendReceive3/SMB2SendReceive/  ?

>
> Also please explain the strategy for phasing out the old API(s) so
> that we won't have three around forever.

That is harder and I don't plan to do so.
SendReceive2 and SendReceiveNoRsp is after this series no longer used by
smb2, but they are still used by SMB1.
SMB1 uses a LOT of different send/receive functions.


I don't want to touch SMB1. I mostly want it to just go away :-)


> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
