From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/8] SMB2 durable handles support
Date: Wed, 10 Jul 2013 12:57:31 -0500
Message-ID: <CAH2r5ms5ag4k49ungfercgPr+q9cBi3HoWCZFYazCSexzb3ZAw@mail.gmail.com>
References: <1373450401-4135-1-git-send-email-pshilovsky@samba.org>
	<CAFB9KM0=SOvVqHsarp9KijoUYeG=7=QwnWZMoJDgajbfPH42ZA@mail.gmail.com>
	<CAKywueRqRxnuqAG5dyZcmCwFpoYk=XU+jMrJ48RvYvPeBH6doA@mail.gmail.com>
	<CAFB9KM30q9N0CXbDJM3O_QrQOpPED+74qnhqkuXaHRhUEd0T=g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAFB9KM30q9N0CXbDJM3O_QrQOpPED+74qnhqkuXaHRhUEd0T=g@mail.gmail.com>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Minor endian warning found and fixed in this series

Author: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Date:   Wed Jul 10 12:50:57 2013 -0500

    Fix minor endian error in durable handle patch series

    Fix endian warning:

      CHECK   fs/cifs/smb2pdu.c
    fs/cifs/smb2pdu.c:1068:40: warning: incorrect type in assignment
(different base types)
    fs/cifs/smb2pdu.c:1068:40:    expected restricted __le32 [usertype] Next
    fs/cifs/smb2pdu.c:1068:40:    got unsigned long

    Signed-off-by: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index c7ad06f..abc9c28 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1065,7 +1065,8 @@ SMB2_open(const unsigned int xid, struct
cifs_open_parms *oparms, __le16 *pat
                if (tcon->ses->server->capabilities & SMB2_GLOBAL_CAP_LEASING) {
                        struct create_context *ccontext =
                            (struct create_context *)iov[num_iovecs-1].iov_base;
-                       ccontext->Next = sizeof(struct create_lease);
+                       ccontext->Next =
+                               cpu_to_le32(sizeof(struct create_lease));
                }
                rc = add_durable_context(iov, &num_iovecs, oparms);
                if (rc) {


On Wed, Jul 10, 2013 at 11:30 AM, Scott Lovenberg
<scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On Wed, Jul 10, 2013 at 12:25 PM, Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
>> 2013/7/10 Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
>>> On Wed, Jul 10, 2013 at 5:59 AM, Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
>>>> This patchset implements SMB2 procotol feature -- durable handles. It allows to restore all file handle information after reconnect events. In particular, there is no need to reobtain byte-range locks.
>>>>
>>>> While adding the feature, the patchset simplifies open codepath by introducing new cifs_open_parms structure.
>>>>
>>>> Pavel Shilovsky (8):
>>>>   CIFS: Fix lease context buffer parsing
>>>>   CIFS: Respect create_options in smb2_open_file
>>>>   CIFS: Simplify SMB2_open code path
>>>>   CIFS: Simplify SMB2 create context handling
>>>>   CIFS: Request durable open for SMB2 opens
>>>>   CIFS: Introduce cifs_open_parms struct
>>>>   CIFS: Make SMB2_open use cifs_open_parms struct
>>>>   CIFS: Reconnect durable handles for SMB2
>>>>
>>>
>>> Forgive my ignorance, but I thought this patch set was merged a while
>>> ago (around the 4.0 release)?  Is this a respin?
>>
>> I think you mean Samba 4.0 release but this patchset is targeted for
>> cifs filesystem kernel client.
>
> D'oh!  Should have had my coffee before posting.  Sorry for the noise.
>
> --
> Peace and Blessings,
> -Scott.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,

Steve
