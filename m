From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] [CIFS] Add structure definitions for SMB2 PDUs
Date: Fri, 11 Mar 2011 17:30:41 -0600
Message-ID: <AANLkTin8Attqgd817=EM6gpB7Fk0SgkF_J4-1fiSwJ1b@mail.gmail.com>
References: <AANLkTin7S9baWgbaHXXVFWx50kj2bsDj-XqdQ-OZ=zzY@mail.gmail.com>
	<20110311145917.6f0e40ea@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110311145917.6f0e40ea-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Mar 11, 2011 at 1:59 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> On Fri, 25 Feb 2011 23:25:08 -0600
> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> =A0+
>> +/* one of these for every pending SMB2 request to the server */
>> +struct smb2_mid_entry {
>> + =A0 =A0 struct list_head qhead; /* mids waiting on reply from this=
 server */
>> + =A0 =A0 __u64 mid; =A0 =A0 =A0 =A0 =A0 =A0 =A0/* multiplex id(s) *=
/
>> + =A0 =A0 __u16 pid; =A0 =A0 =A0 =A0 =A0 =A0 =A0/* process id */
>> + =A0 =A0 __u32 sequence_number; =A0/* for signing */ /* BB check if=
 needed */
>> + =A0 =A0 unsigned long when_alloc; =A0/* when mid was created */
>> +#ifdef CONFIG_CIFS_STATS2
>> + =A0 =A0 unsigned long when_sent; /* time when smb send finished */
>> + =A0 =A0 unsigned long when_received; /* when demux complete (taken=
 off wire) */
>> +#endif
>> + =A0 =A0 struct task_struct *tsk; =A0 =A0 =A0 =A0/* task waiting fo=
r response */
>> + =A0 =A0 struct smb2_hdr *resp_buf; =A0 =A0 =A0/* response buffer *=
/
>> + =A0 =A0 char **pagebuf_list; =A0 =A0 =A0 =A0 =A0 =A0/* response bu=
ffer */
>> + =A0 =A0 int num_pages;
>> + =A0 =A0 int mid_state; =A0/* wish this were enum but can not pass =
to wait_event */
>> + =A0 =A0 __le16 command; /* smb command code */
>> + =A0 =A0 bool async_resp_rcvd:1; /* if server has responded with in=
terim resp */
>> + =A0 =A0 bool large_buf:1; =A0 =A0 =A0 /* if valid response, is poi=
nter to large buf */
>> + =A0 =A0 bool is_kmap_buf:1;
>> +/* =A0 bool multi_rsp:1; BB do we have to account for something in =
SMB2 like
>> + =A0 =A0 we saw multiple trans2 responses for one request (possible=
 in CIFS) */
>> + =A0 =A0 /* Async things */
>> + =A0 =A0 __u64 *mid_list; =A0 =A0 =A0 =A0/* multiplex id(s) */
>> + =A0 =A0 int *mid_state_list;
>> + =A0 =A0 short int *large_buf_list;
>> + =A0 =A0 unsigned int num_mid;
>> + =A0 =A0 unsigned int act_num_mid;
>> + =A0 =A0 unsigned int num_received;
>> + =A0 =A0 unsigned int cur_id;
>> + =A0 =A0 struct smb2_hdr **resp_buf_list; =A0 =A0 =A0 =A0/* respons=
e buffer */
>> + =A0 =A0 __le16 *command_list;
>> + =A0 =A0 bool async:1;
>> + =A0 =A0 bool complex_mid:1; /* complex entry - consists of several=
 messages */
>> + =A0 =A0 int result;
>> + =A0 =A0 unsigned long last_rsp_time;
>> + =A0 =A0 int (*callback)(struct smb2_mid_entry * , void *);
>> + =A0 =A0 void *callback_data;
>> +};
>> +
>>
>
> Holy cow, this thing is a porker.
>
> Can we eliminate some of these fields? For instance, you have a
> callback and callback_data field like in the cifs variant, but you al=
so
> have a tsk pointer. That should no longer be needed. There also seem =
to
> be a lot of fields that are not used in any of the code that has yet
> been merged.

I would prefer not to convert Pavel's smb2_writepages code from
the old smb2.git tree to this (in cifs.ko instead of smb2.ko) yet.
There are other pieces of the code conversion that need to
be posted first before we get to Pavel's writepages work (e.g. the
conversion of the transport workers, and as I mentioned in the earlier =
email
the restructuring of cifs_demultiplex to be able to call out to
smb2 handlers).

It sounds riskier to take the smb2 mid fields out (they were
tested, working and mostly reviewed last summer and had been
in tree in the old implementation for a while).   During this part
of the conversion, I want to focus on the things which
changed by moving to this one module approach - the additional sharing
between cifs and smb2 which you had suggested (mostly
around the three, now common, structures - for socket, ses and tcon).
The allocate mid code as a result had to change.


--=20
Thanks,

Steve
