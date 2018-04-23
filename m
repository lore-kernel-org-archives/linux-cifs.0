From: Steve French <smfrench@gmail.com>
Subject: Re: [Patch v2 3/6] cifs: smbd: Avoid allocating iov on the stack
Date: Mon, 23 Apr 2018 12:50:49 -0500
Message-ID: <CAH2r5mtNNGaqH_XteEtzi+GVTB1NFbbwnXBHLygcYMzG2EVdVA@mail.gmail.com>
References: <20180417191710.14855-1-longli@linuxonhyperv.com>
 <20180417191710.14855-3-longli@linuxonhyperv.com> <CAH2r5mv65CGR04f3Z20aRBufisPon5Ptvqk++zii3YT=GN8epQ@mail.gmail.com>
 <SN4PR2101MB0733595DB7FC0A122ADB9128CE890@SN4PR2101MB0733.namprd21.prod.outlook.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="000000000000d8406d056a87ae29"
Cc: CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
To: Long Li <longli@microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <SN4PR2101MB0733595DB7FC0A122ADB9128CE890@SN4PR2101MB0733.namprd21.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

--000000000000d8406d056a87ae29
Content-Type: text/plain; charset="UTF-8"

I am ok with the other style warning - so I just fixed up the one
error (see attached) and merged into cifs-2.6.git for-next

That leaves two more from your series to review (and for others to
review).  Let's just focus on those two.


On Mon, Apr 23, 2018 at 12:33 PM, Long Li <longli@microsoft.com> wrote:
>> Subject: Re: [Patch v2 3/6] cifs: smbd: Avoid allocating iov on the stack
>>
>> Didn't see any obvious problems, but can you fix the checkpatch warnings
>> and resend to the list (I am more concerned about the last two warnings
>> rather than the first one).
>
> Yes, I will fix it and resend.
>
>>
>> $ scripts/checkpatch.pl 0001-cifs-smbd-Avoid-allocating-iov-on-the-
>> stack.patch
>> WARNING: line over 80 characters
>> #60: FILE: fs/cifs/smbdirect.c:2106:
>> +        log_write(ERR, "expected the pdu length in 1st iov, but got
>> 0x%lu\n", rqst->rq_iov[0].iov_len);
>>
>> ERROR: Prefixing 0x with decimal output is defective
>> #60: FILE: fs/cifs/smbdirect.c:2106:
>> +        log_write(ERR, "expected the pdu length in 1st iov, but got
>> 0x%lu\n", rqst->rq_iov[0].iov_len);
>>
>> WARNING: braces {} are not necessary for single statement blocks
>> #69: FILE: fs/cifs/smbdirect.c:2112:
>> +    for (i = 0; i < rqst->rq_nvec-1; i++) {
>>          buflen += iov[i].iov_len;
>>      }
>>
>> total: 1 errors, 2 warnings, 65 lines checked
>>
>> NOTE: For some of the reported defects, checkpatch may be able to
>>       mechanically convert to the typical style using --fix or --fix-inplace.
>>
>> 0001-cifs-smbd-Avoid-allocating-iov-on-the-stack.patch has style problems,
>> please review.
>>
>> On Tue, Apr 17, 2018 at 2:17 PM, Long Li <longli@linuxonhyperv.com> wrote:
>> > From: Long Li <longli@microsoft.com>
>> >
>> > It's not necessary to allocate another iov when going through the
>> > buffers in smbd_send() through RDMA send.
>> >
>> > Remove it to reduce stack size.
>> >
>> > Signed-off-by: Long Li <longli@microsoft.com>
>> > Cc: stable@vger.kernel.org
>> > ---
>> >  fs/cifs/smbdirect.c | 36 ++++++++++++------------------------
>> >  1 file changed, 12 insertions(+), 24 deletions(-)
>> >
>> > diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c index
>> > b5c6c0d..f575e9a 100644
>> > --- a/fs/cifs/smbdirect.c
>> > +++ b/fs/cifs/smbdirect.c
>> > @@ -2088,7 +2088,7 @@ int smbd_send(struct smbd_connection *info,
>> struct smb_rqst *rqst)
>> >         int start, i, j;
>> >         int max_iov_size =
>> >                 info->max_send_size - sizeof(struct smbd_data_transfer);
>> > -       struct kvec iov[SMBDIRECT_MAX_SGE];
>> > +       struct kvec *iov;
>> >         int rc;
>> >
>> >         info->smbd_send_pending++;
>> > @@ -2099,32 +2099,20 @@ int smbd_send(struct smbd_connection *info,
>> struct smb_rqst *rqst)
>> >         }
>> >
>> >         /*
>> > -        * This usually means a configuration error
>> > -        * We use RDMA read/write for packet size >
>> rdma_readwrite_threshold
>> > -        * as long as it's properly configured we should never get into this
>> > -        * situation
>> > -        */
>> > -       if (rqst->rq_nvec + rqst->rq_npages > SMBDIRECT_MAX_SGE) {
>> > -               log_write(ERR, "maximum send segment %x exceeding %x\n",
>> > -                        rqst->rq_nvec + rqst->rq_npages, SMBDIRECT_MAX_SGE);
>> > -               rc = -EINVAL;
>> > -               goto done;
>> > -       }
>> > -
>> > -       /*
>> > -        * Remove the RFC1002 length defined in MS-SMB2 section 2.1
>> > -        * It is used only for TCP transport
>> > +        * Skip the RFC1002 length defined in MS-SMB2 section 2.1
>> > +        * It is used only for TCP transport in the iov[0]
>> >          * In future we may want to add a transport layer under protocol
>> >          * layer so this will only be issued to TCP transport
>> >          */
>> > -       iov[0].iov_base = (char *)rqst->rq_iov[0].iov_base + 4;
>> > -       iov[0].iov_len = rqst->rq_iov[0].iov_len - 4;
>> > -       buflen += iov[0].iov_len;
>> > +
>> > +       if (rqst->rq_iov[0].iov_len != 4) {
>> > +               log_write(ERR, "expected the pdu length in 1st iov, but got
>> 0x%lu\n", rqst->rq_iov[0].iov_len);
>> > +               return -EINVAL;
>> > +       }
>> > +       iov = &rqst->rq_iov[1];
>> >
>> >         /* total up iov array first */
>> > -       for (i = 1; i < rqst->rq_nvec; i++) {
>> > -               iov[i].iov_base = rqst->rq_iov[i].iov_base;
>> > -               iov[i].iov_len = rqst->rq_iov[i].iov_len;
>> > +       for (i = 0; i < rqst->rq_nvec-1; i++) {
>> >                 buflen += iov[i].iov_len;
>> >         }
>> >
>> > @@ -2197,14 +2185,14 @@ int smbd_send(struct smbd_connection *info,
>> struct smb_rqst *rqst)
>> >                                                 goto done;
>> >                                 }
>> >                                 i++;
>> > -                               if (i == rqst->rq_nvec)
>> > +                               if (i == rqst->rq_nvec-1)
>> >                                         break;
>> >                         }
>> >                         start = i;
>> >                         buflen = 0;
>> >                 } else {
>> >                         i++;
>> > -                       if (i == rqst->rq_nvec) {
>> > +                       if (i == rqst->rq_nvec-1) {
>> >                                 /* send out all remaining vecs */
>> >                                 remaining_data_length -= buflen;
>> >                                 log_write(INFO,
>> > --
>> > 2.7.4
>> >
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-cifs"
>> > in the body of a message to majordomo@vger.kernel.org More
>> majordomo
>> > info at
>> >
>> https://na01.safelinks.protection.outlook.com/?url=http%3A%2F%2Fvger.k
>> > ernel.org%2Fmajordomo-
>> info.html&data=02%7C01%7Clongli%40microsoft.com%
>> >
>> 7C23fbdbb0598a497f624708d5a92f6435%7C72f988bf86f141af91ab2d7cd011d
>> b47%
>> >
>> 7C1%7C0%7C636600943380887988&sdata=imh9cWDQQEXqxHdUrCuEykgiLfKs
>> UAl20jB
>> > yPOS7FrI%3D&reserved=0
>>
>>
>>
>> --
>> Thanks,
>>
>> Steve
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in the
>> body of a message to majordomo@vger.kernel.org More majordomo info at
>> https://na01.safelinks.protection.outlook.com/?url=http%3A%2F%2Fvger.ke
>> rnel.org%2Fmajordomo-
>> info.html&data=02%7C01%7Clongli%40microsoft.com%7C23fbdbb0598a497f
>> 624708d5a92f6435%7C72f988bf86f141af91ab2d7cd011db47%7C1%7C0%7C63
>> 6600943380887988&sdata=imh9cWDQQEXqxHdUrCuEykgiLfKsUAl20jByPOS7F
>> rI%3D&reserved=0



-- 
Thanks,

Steve

--000000000000d8406d056a87ae29
Content-Type: text/x-patch; charset="US-ASCII";
	name="0001-cifs-smbd-Avoid-allocating-iov-on-the-stack.patch"
Content-Disposition: attachment;
	filename="0001-cifs-smbd-Avoid-allocating-iov-on-the-stack.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_jgcjelwy0

RnJvbSA1NTMwMTg2NTdkZTI2NWE3Yzk5OWY0ZmQxMjg2NGZkMDY0NjMxOWExIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBMb25nIExpIDxsb25nbGlAbWljcm9zb2Z0LmNvbT4KRGF0ZTog
VHVlLCAxNyBBcHIgMjAxOCAxMjoxNzowNyAtMDcwMApTdWJqZWN0OiBbUEFUQ0hdIGNpZnM6IHNt
YmQ6IEF2b2lkIGFsbG9jYXRpbmcgaW92IG9uIHRoZSBzdGFjawoKSXQncyBub3QgbmVjZXNzYXJ5
IHRvIGFsbG9jYXRlIGFub3RoZXIgaW92IHdoZW4gZ29pbmcgdGhyb3VnaCB0aGUgYnVmZmVycwpp
biBzbWJkX3NlbmQoKSB0aHJvdWdoIFJETUEgc2VuZC4KClJlbW92ZSBpdCB0byByZWR1Y2Ugc3Rh
Y2sgc2l6ZS4KClNpZ25lZC1vZmYtYnk6IExvbmcgTGkgPGxvbmdsaUBtaWNyb3NvZnQuY29tPgpD
Yzogc3RhYmxlQHZnZXIua2VybmVsLm9yZwotLS0KIGZzL2NpZnMvc21iZGlyZWN0LmMgfCAzNiAr
KysrKysrKysrKystLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KIDEgZmlsZSBjaGFuZ2VkLCAxMiBp
bnNlcnRpb25zKCspLCAyNCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9mcy9jaWZzL3NtYmRp
cmVjdC5jIGIvZnMvY2lmcy9zbWJkaXJlY3QuYwppbmRleCA4NzgxN2RkY2MwOTYuLjI0Y2VhNjNl
MTdmNSAxMDA2NDQKLS0tIGEvZnMvY2lmcy9zbWJkaXJlY3QuYworKysgYi9mcy9jaWZzL3NtYmRp
cmVjdC5jCkBAIC0yMDg2LDcgKzIwODYsNyBAQCBpbnQgc21iZF9zZW5kKHN0cnVjdCBzbWJkX2Nv
bm5lY3Rpb24gKmluZm8sIHN0cnVjdCBzbWJfcnFzdCAqcnFzdCkKIAlpbnQgc3RhcnQsIGksIGo7
CiAJaW50IG1heF9pb3Zfc2l6ZSA9CiAJCWluZm8tPm1heF9zZW5kX3NpemUgLSBzaXplb2Yoc3Ry
dWN0IHNtYmRfZGF0YV90cmFuc2Zlcik7Ci0Jc3RydWN0IGt2ZWMgaW92W1NNQkRJUkVDVF9NQVhf
U0dFXTsKKwlzdHJ1Y3Qga3ZlYyAqaW92OwogCWludCByYzsKIAogCWluZm8tPnNtYmRfc2VuZF9w
ZW5kaW5nKys7CkBAIC0yMDk2LDMyICsyMDk2LDIwIEBAIGludCBzbWJkX3NlbmQoc3RydWN0IHNt
YmRfY29ubmVjdGlvbiAqaW5mbywgc3RydWN0IHNtYl9ycXN0ICpycXN0KQogCX0KIAogCS8qCi0J
ICogVGhpcyB1c3VhbGx5IG1lYW5zIGEgY29uZmlndXJhdGlvbiBlcnJvcgotCSAqIFdlIHVzZSBS
RE1BIHJlYWQvd3JpdGUgZm9yIHBhY2tldCBzaXplID4gcmRtYV9yZWFkd3JpdGVfdGhyZXNob2xk
Ci0JICogYXMgbG9uZyBhcyBpdCdzIHByb3Blcmx5IGNvbmZpZ3VyZWQgd2Ugc2hvdWxkIG5ldmVy
IGdldCBpbnRvIHRoaXMKLQkgKiBzaXR1YXRpb24KLQkgKi8KLQlpZiAocnFzdC0+cnFfbnZlYyAr
IHJxc3QtPnJxX25wYWdlcyA+IFNNQkRJUkVDVF9NQVhfU0dFKSB7Ci0JCWxvZ193cml0ZShFUlIs
ICJtYXhpbXVtIHNlbmQgc2VnbWVudCAleCBleGNlZWRpbmcgJXhcbiIsCi0JCQkgcnFzdC0+cnFf
bnZlYyArIHJxc3QtPnJxX25wYWdlcywgU01CRElSRUNUX01BWF9TR0UpOwotCQlyYyA9IC1FSU5W
QUw7Ci0JCWdvdG8gZG9uZTsKLQl9Ci0KLQkvKgotCSAqIFJlbW92ZSB0aGUgUkZDMTAwMiBsZW5n
dGggZGVmaW5lZCBpbiBNUy1TTUIyIHNlY3Rpb24gMi4xCi0JICogSXQgaXMgdXNlZCBvbmx5IGZv
ciBUQ1AgdHJhbnNwb3J0CisJICogU2tpcCB0aGUgUkZDMTAwMiBsZW5ndGggZGVmaW5lZCBpbiBN
Uy1TTUIyIHNlY3Rpb24gMi4xCisJICogSXQgaXMgdXNlZCBvbmx5IGZvciBUQ1AgdHJhbnNwb3J0
IGluIHRoZSBpb3ZbMF0KIAkgKiBJbiBmdXR1cmUgd2UgbWF5IHdhbnQgdG8gYWRkIGEgdHJhbnNw
b3J0IGxheWVyIHVuZGVyIHByb3RvY29sCiAJICogbGF5ZXIgc28gdGhpcyB3aWxsIG9ubHkgYmUg
aXNzdWVkIHRvIFRDUCB0cmFuc3BvcnQKIAkgKi8KLQlpb3ZbMF0uaW92X2Jhc2UgPSAoY2hhciAq
KXJxc3QtPnJxX2lvdlswXS5pb3ZfYmFzZSArIDQ7Ci0JaW92WzBdLmlvdl9sZW4gPSBycXN0LT5y
cV9pb3ZbMF0uaW92X2xlbiAtIDQ7Ci0JYnVmbGVuICs9IGlvdlswXS5pb3ZfbGVuOworCisJaWYg
KHJxc3QtPnJxX2lvdlswXS5pb3ZfbGVuICE9IDQpIHsKKwkJbG9nX3dyaXRlKEVSUiwgImV4cGVj
dGVkIHRoZSBwZHUgbGVuZ3RoIGluIDFzdCBpb3YsIGJ1dCBnb3QgJWx1XG4iLCBycXN0LT5ycV9p
b3ZbMF0uaW92X2xlbik7CisJCXJldHVybiAtRUlOVkFMOworCX0KKwlpb3YgPSAmcnFzdC0+cnFf
aW92WzFdOwogCiAJLyogdG90YWwgdXAgaW92IGFycmF5IGZpcnN0ICovCi0JZm9yIChpID0gMTsg
aSA8IHJxc3QtPnJxX252ZWM7IGkrKykgewotCQlpb3ZbaV0uaW92X2Jhc2UgPSBycXN0LT5ycV9p
b3ZbaV0uaW92X2Jhc2U7Ci0JCWlvdltpXS5pb3ZfbGVuID0gcnFzdC0+cnFfaW92W2ldLmlvdl9s
ZW47CisJZm9yIChpID0gMDsgaSA8IHJxc3QtPnJxX252ZWMtMTsgaSsrKSB7CiAJCWJ1ZmxlbiAr
PSBpb3ZbaV0uaW92X2xlbjsKIAl9CiAKQEAgLTIxOTgsMTQgKzIxODYsMTQgQEAgaW50IHNtYmRf
c2VuZChzdHJ1Y3Qgc21iZF9jb25uZWN0aW9uICppbmZvLCBzdHJ1Y3Qgc21iX3Jxc3QgKnJxc3Qp
CiAJCQkJCQlnb3RvIGRvbmU7CiAJCQkJfQogCQkJCWkrKzsKLQkJCQlpZiAoaSA9PSBycXN0LT5y
cV9udmVjKQorCQkJCWlmIChpID09IHJxc3QtPnJxX252ZWMtMSkKIAkJCQkJYnJlYWs7CiAJCQl9
CiAJCQlzdGFydCA9IGk7CiAJCQlidWZsZW4gPSAwOwogCQl9IGVsc2UgewogCQkJaSsrOwotCQkJ
aWYgKGkgPT0gcnFzdC0+cnFfbnZlYykgeworCQkJaWYgKGkgPT0gcnFzdC0+cnFfbnZlYy0xKSB7
CiAJCQkJLyogc2VuZCBvdXQgYWxsIHJlbWFpbmluZyB2ZWNzICovCiAJCQkJcmVtYWluaW5nX2Rh
dGFfbGVuZ3RoIC09IGJ1ZmxlbjsKIAkJCQlsb2dfd3JpdGUoSU5GTywKLS0gCjIuMTQuMQoK
--000000000000d8406d056a87ae29--
