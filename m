From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] [CIFS] Add structure definitions for SMB2 PDUs
Date: Fri, 11 Mar 2011 17:24:06 -0600
Message-ID: <AANLkTimsb8rgaQVZOUqjCGLzfm8g2gFyM+J_Ar9w8mY1@mail.gmail.com>
References: <AANLkTin7S9baWgbaHXXVFWx50kj2bsDj-XqdQ-OZ=zzY@mail.gmail.com>
	<20110311145917.6f0e40ea@tlielax.poochiereds.net>
	<20110311150400.59aaaba3@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110311150400.59aaaba3-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Mar 11, 2011 at 2:04 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> On Fri, 11 Mar 2011 14:59:17 -0500
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
>> On Fri, 25 Feb 2011 23:25:08 -0600
>> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> =A0+
>> > +/* one of these for every pending SMB2 request to the server */
>> > +struct smb2_mid_entry {
>> > + =A0 struct list_head qhead; /* mids waiting on reply from this s=
erver */
>> > + =A0 __u64 mid; =A0 =A0 =A0 =A0 =A0 =A0 =A0/* multiplex id(s) */
>> > + =A0 __u16 pid; =A0 =A0 =A0 =A0 =A0 =A0 =A0/* process id */
>> > + =A0 __u32 sequence_number; =A0/* for signing */ /* BB check if n=
eeded */
>> > + =A0 unsigned long when_alloc; =A0/* when mid was created */
>> > +#ifdef CONFIG_CIFS_STATS2
>> > + =A0 unsigned long when_sent; /* time when smb send finished */
>> > + =A0 unsigned long when_received; /* when demux complete (taken o=
ff wire) */
>> > +#endif
>> > + =A0 struct task_struct *tsk; =A0 =A0 =A0 =A0/* task waiting for =
response */
>> > + =A0 struct smb2_hdr *resp_buf; =A0 =A0 =A0/* response buffer */
>> > + =A0 char **pagebuf_list; =A0 =A0 =A0 =A0 =A0 =A0/* response buff=
er */
>> > + =A0 int num_pages;
>> > + =A0 int mid_state; =A0/* wish this were enum but can not pass to=
 wait_event */
>> > + =A0 __le16 command; /* smb command code */
>> > + =A0 bool async_resp_rcvd:1; /* if server has responded with inte=
rim resp */
>> > + =A0 bool large_buf:1; =A0 =A0 =A0 /* if valid response, is point=
er to large buf */
>> > + =A0 bool is_kmap_buf:1;
>> > +/* bool multi_rsp:1; BB do we have to account for something in SM=
B2 like
>> > + =A0 we saw multiple trans2 responses for one request (possible i=
n CIFS) */
>> > + =A0 /* Async things */
>> > + =A0 __u64 *mid_list; =A0 =A0 =A0 =A0/* multiplex id(s) */
>> > + =A0 int *mid_state_list;
>> > + =A0 short int *large_buf_list;
>> > + =A0 unsigned int num_mid;
>> > + =A0 unsigned int act_num_mid;
>> > + =A0 unsigned int num_received;
>> > + =A0 unsigned int cur_id;
>> > + =A0 struct smb2_hdr **resp_buf_list; =A0 =A0 =A0 =A0/* response =
buffer */
>> > + =A0 __le16 *command_list;
>> > + =A0 bool async:1;
>> > + =A0 bool complex_mid:1; /* complex entry - consists of several m=
essages */
>> > + =A0 int result;
>> > + =A0 unsigned long last_rsp_time;
>> > + =A0 int (*callback)(struct smb2_mid_entry * , void *);
>> > + =A0 void *callback_data;
>> > +};
>> > +
>> >
>>
>> Holy cow, this thing is a porker.
>>
>> Can we eliminate some of these fields? For instance, you have a
>> callback and callback_data field like in the cifs variant, but you a=
lso
>> have a tsk pointer. That should no longer be needed. There also seem=
 to
>> be a lot of fields that are not used in any of the code that has yet
>> been merged. Much of it is really unclear.
>>
>> This seems like a real red flag to me. Dumping code into the tree li=
ke
>> this en-masse is a recipe for bloat and waste. Adding structs for
>> protocol definitions is one thing, adding things like this that seem=
 to
>> have no rhyme or reason is quite another.
>>
>
> To be clear...
>
> It's impossible for anyone to reasonably review this. There's no
> context. Adding structures like this only makes sense if there is
> actual code to use them.

I sent you and a few others the mid allocation code (it is reasonably
close to what cifs does so should not be an issue).  The struct itself
has fields which are different for the reasons I noted (the other few
fields were added during the Google Summer of Code async writepages
work that Pavel did last summer in the smb2.git tree).



--=20
Thanks,

Steve
