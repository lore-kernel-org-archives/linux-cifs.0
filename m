From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] common: enable tests that require scratch device on CIFS
Date: Wed, 12 Nov 2014 22:40:35 -0600
Message-ID: <CAH2r5mt_fvF1dvmbWPq=TBrXgTiyd-xmMgQjQA7+hqb3=1qWFQ@mail.gmail.com>
References: <1415617191-17246-1-git-send-email-eguan@redhat.com>
 <CAH2r5muXH7HSoM0TQUsPXq1RM-dLdZSfzuOKK1zZdKe0OANAhg@mail.gmail.com>
 <20141110160309.GI2863@dhcp-13-216.nay.redhat.com> <CAH2r5mtCPVt7+fyCjvDrLtOSzX1-+YQ_ZPhyU5gjFP7c1DJFKw@mail.gmail.com>
 <20141113032824.GB28565@dastard> <CAH2r5mtEq0gyNn+8+_UzDc0KRskHnnzDHipa=hqeFOf8y1jH1A@mail.gmail.com>
 <20141113042756.GE28565@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Eryu Guan <eguan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, fstests-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141113042756.GE28565@dastard>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Nov 12, 2014 at 10:27 PM, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org> wrote:
> On Wed, Nov 12, 2014 at 10:08:34PM -0600, Steve French wrote:
>> On Wed, Nov 12, 2014 at 9:28 PM, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org> wrote:
>> > On Wed, Nov 12, 2014 at 05:26:13PM -0600, Steve French wrote:
>> >> I get newly enabled test 294 passing on cifs mounts to Samba.
>> >>
>> >> What is best way to get the mount options passed to the mount of
>> >> scratch dev so it doesn't prompt for it?
>> >
>> > # MOUNT_OPTIONS="-o ...." ./check -g auto
>>
>> much better - that worked - thanks
>>
>> I had been using TEST_FS_MOUNT_OPTS (so I could have multiple sections
>> in local.config) rather
>> than MOUNT_OPTIONS
>
> BTW, why aren't you using CIFS_MOUNT_OPTIONS to define the login
> creds for both the test and scratch devices? That's what it was
> added for....

When specifying multiple sections in local.config (a common case for us
is to have one section to run tests with cifs dialect, then run again with
smb2, then again with smb3 dialect etc.). Pavel had indicated that to do this
you must use TEST_FS_MOUNT_OPTS instead of CIFS_MOUNT_OPTIONS
if you have multiple sections.  I haven't found a way around this.

Specifying the username/password in TEST_FS_MOUNT_OPTS does
work for the TEST mount but not for the SCRATCH mount (but as you
mentioned does work if you specify MOUNT_OPTIONS)
-- 
Thanks,

Steve
