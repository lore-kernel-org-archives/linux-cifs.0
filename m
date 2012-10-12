From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: cifs
Date: Fri, 12 Oct 2012 14:50:02 -0400
Message-ID: <20121012145002.0e4b425a@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi Shirish,

I'm looking at implementing a plugin interface for the idmap code for cifs-utils:

    https://bugzilla.samba.org/show_bug.cgi?id=9203

While looking over the existing code, I ran across this. The kernel and
setcifsacl use this struct for SIDs:

struct cifs_sid {
        uint8_t revision; /* revision level */
        uint8_t num_subauth;
        uint8_t authority[6];
        uint32_t sub_auth[5]; /* sub_auth[num_subauth] */
};

...however, the wbclient libs have this:

#ifndef WBC_MAXSUBAUTHS
#define WBC_MAXSUBAUTHS 15 /* max sub authorities in a SID */
#endif

struct wbcDomainSid {
        uint8_t   sid_rev_num;
        uint8_t   num_auths;
        uint8_t   id_auth[6];
        uint32_t  sub_auths[WBC_MAXSUBAUTHS];
};

Now, when the cifs.idmap program downcalls with a SID, it does this:

     rc = keyctl_instantiate(key, &sid, sizeof(struct wbcDomainSid), 0);

The kernel then copies that to a buffer and then copies that into a
cifs_sid locally. It doesn't seem to care much about the sizes there so
anything beyond sub_auths[4] is ignored.

Is that a problem? If not, why not?

Thanks,
-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
