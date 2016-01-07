From: Jeff Layton <jlayton@samba.org>
Subject: Re: [PATCH] manpage: clarify use of backupuid and backupgid in
 mount.cifs.8
Date: Thu, 7 Jan 2016 07:57:59 -0500
Message-ID: <20160107075759.0b79012e@tlielax.poochiereds.net>
References: <1447962495-14738-1-git-send-email-uri@samba.org>
 <1447962495-14738-2-git-send-email-uri@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
 Uri Simchoni <uri@samba.org>
To: Uri Simchoni <urisimchoni@gmail.com>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <1447962495-14738-2-git-send-email-uri@samba.org>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>,
 <mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical/>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>,
 <mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Errors-To: samba-technical-bounces@lists.samba.org
Sender: "samba-technical" <samba-technical-bounces@lists.samba.org>
List-Id: linux-cifs.vger.kernel.org

On Thu, 19 Nov 2015 21:48:15 +0200
Uri Simchoni <urisimchoni@gmail.com> wrote:

> Assert that backup intent shall only be attempted if the user matches
> the backupuid or backupgid parameter.
> 
> Signed-off-by: Uri Simchoni <uri@samba.org>
> ---
>  mount.cifs.8 | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/mount.cifs.8 b/mount.cifs.8
> index 2643145..af6b097 100644
> --- a/mount.cifs.8
> +++ b/mount.cifs.8
> @@ -310,14 +310,14 @@ for more information\&.
>  .PP
>  backupuid=\fIarg\fR
>  .RS 4
> -Restrict access to files with the backup intent to a user. Either a name or an id must be provided as an argument, there are no default values.
> +File access by this user shall be done with the backup intent flag set. Either a name or an id must be provided as an argument, there are no default values.
>  .sp
>  See section \fIACCESSING FILES WITH BACKUP INTENT\fR for more details
>  .RE
>  .PP
>  backupgid=\fIarg\fR
>  .RS 4
> -Restrict access to files with the backup intent to a group. Either a name or an id must be provided as an argument, there are no default values.
> +File access by users who are members of this group shall be done with the backup intent flag set. Either a name or an id must be provided as an argument, there are no default values.
>  .sp
>  See section \fIACCESSING FILES WITH BACKUP INTENT\fR for more details
>  .RE
> @@ -767,7 +767,7 @@ But the user testuser, if it becomes part of the group Backup Operators, can ope
>  Any user on the client side who can authenticate as such a user on the server,
>  can access the files with the backup intent. But it is desirable and preferable for security reasons amongst many, to restrict this special right.
>  
> -The mount option backupuid is used to restrict this special right to a user which is specified by either a name or an id. The mount option backupgid is used to restrict this special right to the users in a group which is specified by either a name or an id. These two mount options can be used together.
> +The mount option backupuid is used to restrict this special right to a user which is specified by either a name or an id. The mount option backupgid is used to restrict this special right to the users in a group which is specified by either a name or an id. Only users maching either backupuid or backupgid shall attempt to access files with backup intent. These two mount options can be used together.
>  .SH "FILE AND DIRECTORY OWNERSHIP AND PERMISSIONS"
>  .PP
>  The core CIFS protocol does not provide unix ownership information or mode for files and directories\&. Because of this, files and directories will generally appear to be owned by whatever values the uid= or gid= options are set, and will have permissions set to the default file_mode and dir_mode for the mount\&. Attempting to change these values via chmod/chown will return success but have no effect\&.

Merged...

Apologies for not spotting this sooner. In the future if you send the
patches to me directly, I'm more likely to see them.

Thanks,
-- 
Jeff Layton <jlayton@samba.org>
