From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: Use mask of ACEs for SID Everyone to calculate all
 three permissions user, group, and other
Date: Mon, 17 Jan 2011 15:05:50 -0600
Message-ID: <AANLkTinYZYY4RFDDwMCx8nYp6FgufLyxwaCj4Fm14RYX@mail.gmail.com>
References: <1291669006-12102-1-git-send-email-shirishpargaonkar@gmail.com>
	<20110104141130.2cec2a74@tlielax.poochiereds.net>
	<AANLkTikhkFnU0B+0JbUXwZvOfVdY_XB67oEaiyaajT0H@mail.gmail.com>
	<20110104143122.46627c31@tlielax.poochiereds.net>
	<AANLkTimT4AKX0HYCMcZiMXvXV-N0r23yGQ+oU=CDdi-w@mail.gmail.com>
	<20110104150934.3ba10652@tlielax.poochiereds.net>
	<AANLkTik38rcit3PJc1d0WU7+kS4a39UTaQ6TuRN+H_if@mail.gmail.com>
	<20110113104834.1583ec39@barsoom.rdu.redhat.com>
	<AANLkTin6t6qoQe7weUkKwNHBPvXkSEbQ9-b16+5A_HpE@mail.gmail.com>
	<20110114100843.2d6b5dbb@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlaIyton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110114100843.2d6b5dbb-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Jan 14, 2011 at 9:08 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Thu, 13 Jan 2011 14:45:59 -0600
> Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> >
>> > What exactly do you intend to protect with client-side enforcement?
>>
>> Jeff, with client side permission checking/enforcment, as I understand,
>> we are checking for accesses (read, write, etc.). Is that correct or
>> is there more to that?
>>
>
> There's (far) more to it than that. As I said, the server is going to
> enforce permissions based on the user in the SMB session. So, if you
> enforce permissions on the client, then what you end up with is a
> permissions set comprised of the permissions you're enforcing on the
> client logically AND'ed with those that the server enforces.
>
> Even if you were able to present that somehow, there are significant
> problems with trying to enforce permissions on the client, particularly
> in the face of file and directory creation. Look at it this way:
>
> Suppose that you get idmapping working and find a way to perfectly map
> ACLs to modes on the client. At that point, you'll have file ownership
> and mode that reflects the permissions on file. So, the situation at
> that point is very similar to the situation where unix extensions are
> enabled and the uid/gid are identically mapped on client and server.
>

Would you be OK if patches are posted so that cifsacl mount option
code reaches upto this level i.e. permission enforcement is still
broken and needs to be fixed but at lease owner/group/mode info
is available?

> This is a simple configuration to set up, so let me give you a simple
> "exercise" in such a configuration:
>
> Mount up a share using a set of credentials that map to "alice" on
> the server. On the client, become user "bob". cd into a world-writeable
> directory on the cifs mount and "touch" a file that does not yet exist:
>
> [bob@client]$ touch bob
> touch: cannot touch `bob': Permission denied
> [bob@client]$ ls -l bob
> -rw-r--r--. 1 alice alice 0 Jan 14 09:31 bob
>
> ...so what happened here? The file was created, but because the
> credentials don't map to "bob", it's owned by "alice". The utimes() call
> then failed due to client side permissions enforcement (bob doesn't
> have write access) and "touch" returned an error.

This is what I do not understand. The user "alice" may_not/need_not
exist on the client system at all.
I am not 100% sure but it may be possible, on the server,
access and ownership setup is such that even if user "alice"
can create a file, file owner and owning group may be be
completely different (SID(s)).

In this case, server should have decided whether authenticated
SMB session user "alice" can create a file and whether "alice" has
write access to it.  User "bob" on the client system has no role
here, the client user "bob" does not even exist as far as server
is concerned.

>
> There are similar problems with directory creation (can't create new
> entries in a directory that you just created), and with file/directory
> removal (can't remove a file or directory that you just created). It's
> easy to run afoul of this.
>
> The lesson here is that inode creates matter, and you can't work around
> this fact if you're enforcing permissions on the client. This is horribly
> confusing to users. There are many examples over the years of cifs
> users complaining about this when unix extensions are enabled.
>
> There's another problem too...you can only enforce the permissions that
> you *have*. Even if you can perfectly map/enforce permissions on the
> client, it's easily possible for them to change after you fetch them.
>
> Even if you were to fetch the ACL prior to every access (which would be
> horrible for performance), you still have a race window between
> fetching the ACL and enforcing it.

But is it not an issue with some of the other cifs/smb commands as well?
If you fetch some info about a file, by the time an app on the client
receives that info to make a decision, that info has changed on the server?
Why not accept a reply from the server at that time
>
> These problems with permissions are the primary reason why I did the
> multiuser mount code. After working on this problem and answering
> questions from confused users for a couple of years, I came to the
> conclusion that the only sensible fix is to avoid permissions
> enforcement on the client altogether.

I agree. Enforcement has to be by the server.  But how does server
enforce permissions when there is no means to send such a request
to the server?

>
> But...cifs mounts are single-user by default. People often use the inode
> permissions to restrict access to the mount. What we probably ought to
> consider doing there is setting the i_mode according to the
> file_mode/dir_mode options and enforce them on the client using that.
> If unix extensions or cifsacl are enabled, then store the mode in a
> separate place in the cifsInodeInfo and present that in the getattr
> call. It's still confusing but that makes a heck of a lot more sense than
> what we have now.

I am not sure I understand how file_mode/dir_mode will help but
first thought is, the files will appear different on different mounts
based on file_mode/dir_mode mount options.  That can confuse
users too right?

So IMHO, it is better to ignore uid/gid/file_mode/dir_mode when
presenting file info from a mapped share for the sake of
information consistency.
And actions (such as creation, permission etc.) should be decided
by the server when client sends a request, solely based on the
privileges that authenticated SMB session user id/SID has.

>
> In any case, I'm not keen on the idea of adding yet another way to set
> the mode on files until we have a sane way of dealing with some of the
> existing problems. If you want to first sort out the mess with
> permissions and unix extensions, then I might be more interested.
>
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>
