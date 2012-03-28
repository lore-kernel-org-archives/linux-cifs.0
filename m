From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: re: cifs: use standard token parser for mount options
Date: Wed, 28 Mar 2012 12:13:01 +0100
Message-ID: <1332933181.2144.11.camel@localhost>
References: <20120328104541.GC29022@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120328104541.GC29022-mgFCXtclrQlZLf2FXnZxJA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hello Dan, 

You are right.

On Wed, 2012-03-28 at 13:45 +0300, Dan Carpenter wrote:
> Hello Sachin Prabhu,
> 
> This is a semi-automatic email about new static checker warnings.
> 
> The patch 8830d7e07a5e: "cifs: use standard token parser for mount 
> options" from Mar 23, 2012, leads to the following Smatch complaint:
> 
> fs/cifs/connect.c:1607 cifs_parse_mount_options()
> 	 error: we previously assumed 'value' could be null (see line 1568)
> 
> fs/cifs/connect.c
>   1567				value = strchr(data, '=');
>   1568				if (value != NULL)
>                                     ^^^^^^^^^^^^^
> Check.

static const match_table_t cifs_mount_option_tokens = {
..
        { Opt_pass, "pass=%s" },
        { Opt_pass, "password=%s" },
..
^^^ The parser will only match Opt_pass if the token passed contains a
'=' character so value cannot be NULL. That check for NULL is
unnecessary and shouldn't be there. This is otherwise harmless.

This is an artifact of the old code which was backported. Opt_pass
needed special handling to allow it to process password with ','
characters in them. This bit of code was at top of the while loop and
was used to parse the values passed with the mount option. This was set
to point to the value in case the mount option was passed with a value
or set to NULL in case it was parsing mount options which didn't pass
any values. 
In this case, the Opt_pass will be called only when it contains a value.
The case where a blank password was set is handled separately with
Opt_blank_pass.

> 
>   1569					*value++ = '\0';
>   1570	
>   1571				/* Set tmp_end to end of the string */
>   1572				tmp_end = (char *) value + strlen(value);
>                                                                   ^^^^^
> We can't run strlen() on NULL pointers.
> 
>   1573	
>   1574				/* Check if following character is the deliminator
> 
> regards,
> dan carpenter

Sachin Prabhu
