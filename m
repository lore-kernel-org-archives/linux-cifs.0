From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: cifs
Date: Sat, 13 Oct 2012 22:08:05 -0500
Message-ID: <CADT32eLVmahaU1V1sASrVOMAqr3fo5yDGy21LAtTgHSxASaggA@mail.gmail.com>
References: <20121012145002.0e4b425a@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121012145002.0e4b425a-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Oct 12, 2012 at 1:50 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> Hi Shirish,
>
> I'm looking at implementing a plugin interface for the idmap code for cifs-utils:
>
>     https://bugzilla.samba.org/show_bug.cgi?id=9203
>
> While looking over the existing code, I ran across this. The kernel and
> setcifsacl use this struct for SIDs:
>
> struct cifs_sid {
>         uint8_t revision; /* revision level */
>         uint8_t num_subauth;
>         uint8_t authority[6];
>         uint32_t sub_auth[5]; /* sub_auth[num_subauth] */
> };
>
> ...however, the wbclient libs have this:
>
> #ifndef WBC_MAXSUBAUTHS
> #define WBC_MAXSUBAUTHS 15 /* max sub authorities in a SID */
> #endif
>
> struct wbcDomainSid {
>         uint8_t   sid_rev_num;
>         uint8_t   num_auths;
>         uint8_t   id_auth[6];
>         uint32_t  sub_auths[WBC_MAXSUBAUTHS];
> };
>
> Now, when the cifs.idmap program downcalls with a SID, it does this:
>
>      rc = keyctl_instantiate(key, &sid, sizeof(struct wbcDomainSid), 0);
>
> The kernel then copies that to a buffer and then copies that into a
> cifs_sid locally. It doesn't seem to care much about the sizes there so
> anything beyond sub_auths[4] is ignored.
>
> Is that a problem? If not, why not?
>
> Thanks,
> --
> Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>

Jeff, I have not encountered any SIDs that has more than five
sub auth values.  But I have mostly worked and tested this code
with Windows 2003 Server.
Most of the System Groups and Built-in Accounts there have
less than five sub auth values but some User Accounts have had
five sub auth values.

It is possible that number of sub authorities does can exceed five.
Where can we find an authoritative document that can state so?
I think it would be alright to bump up the value from 5 to
WBC_MAXSUBAUTHS but would be nice to know what can be the
maximum value of sub authorities in a Security Descriptor.

Regards,

Shirish
