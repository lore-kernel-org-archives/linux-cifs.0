From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 1/4] keys: add a "secret" key type
Date: Tue, 17 Jan 2012 19:32:08 +0000
Message-ID: <28618.1326828728@redhat.com>
References: <1325878247-12030-2-git-send-email-jlayton@redhat.com> <1325878247-12030-1-git-send-email-jlayton@redhat.com>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, keyrings-6DNke4IJHB0gsBAKwltoeQ@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1325878247-12030-2-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> For CIFS, we want to be able to store NTLM credentials (aka username
> and password) in the keyring. We do not, however want to allow users
> to fetch those keys back out of the keyring since that would be a
> security risk.
> 
> Unfortunately, due to the nuances of key permission bits, it's not
> possible to do this. We need to grant search permissions so the kernel
> can find these keys, but that also implies permissions to read the
> payload.

That was, perhaps, a bad design decision.  I attempted to make the use of keys
symmetric between the kernel services and userspace tools.  The kernel only has
to be able to find a key to use it, whereas userspace has to be able to *read*
a key to be able to use it - unless it can ask a kernel service to use the key
on its behalf.  SELinux can then be used to restrict who *actually* gets
permission.

I think I need to consider one of a couple of options: (a) simply retracting
read permission on Search permission only or (b) ACLs, so that a use of a key
can be granted directly to a userspace tool.  There may be other options also.

> Resolve this by adding a new key_type. This key type is essentially
> the same as key_type_user, but does not define a .read op. This
> prevents the payload from ever being visible from userspace.

I'm not fond of the idea of adding a completely open key type with no
restrictions on it.  user-defined keys do have an honorary restriction on their
descriptions, as stated in the documentation, for instance in the add_key()
manual page it says:

       "user" Keys  of  the  user-defined key type may contain a blob of arbi-
              trary data, and the description may be any valid string,  though
              it  is  preferred that the description be prefixed with a string
              representing the service to which the key is of interest  and  a
              colon  (for  instance "afs:mykey").  The payload may be empty or
              NULL for keys of this type.

If there are no restrictions at all, then you have a problem with potential
collisions in description space when multiple users start to use it.
Furthermore, you also have no vetting of the payload and no suppression of
updates to it, which means that the kernel has to recheck the payload each
time it gets a lock on it with the intent to make use of it.

I would prefer to see one or more of the following:

 (1) A key type more specific to the data contained.

     This has a couple of practical benefits: it is easier to discard a whole
     class of keys and easier to write useful restrictions on the description
     and payload; and it makes for faster searching as keys of different types
     are detected by pointer comparison whereas keys of the same type have to
     go to the type's ->match() op and potentially do string comparisons.

     It could still be relatively generic, say 'foreign_id'

 (2) Restrictions on the description, particularly if it is a generic key type.

     There exists a ->vet_description() method in the key type.  This can be
     used to make sure the description is suitable for the purpose intended.
     At the very least, if the key type is generic, I would very much prefer to
     see the key type being prefixed with a subclass (say "foo:"), and the vet
     function can check that there's a non-empty length string followed by a
     colon.

 (3) Checks on the payload; perhaps even a parsing of the payload into structs
     that are then attached to the key.  This might obviate the need for checks
     each time the key is used.

And then Documentation/security/ needs some additions...  But that's fine to be
done in a follow-up patch.  If the key is a generic key I'll need an addition
for the add_key() manual page too.

David
