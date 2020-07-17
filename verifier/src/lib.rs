#[cfg(crux)]
pub extern crate crucible;

#[macro_export]
macro_rules! assume {
    ($condition:expr) => {
        if cfg!(crux) {
            $crate::crucible::crucible_assume!($condition)
        } else {
            assert!($condition);
        }
    };
}

#[macro_export]
macro_rules! assert {
    ($condition:expr) => {
        if cfg!(crux) {
            $crate::crucible::crucible_assert!($condition)
        } else {
            assert!($condition);
        }
    };
}

#[macro_export]
macro_rules! assert_eq {
    ($left:expr, $right:expr) => (
        if cfg!(crux) {
            $crate::crucible::crucible_assert!($left == $right);
        } else {
            std::assert_eq!($left, $right);
        }
    );
}

#[macro_export]
macro_rules! assert_ne {
    ($left:expr, $right:expr) => (
        if cfg!(crux) {
            $crate::crucible::crucible_assert!($left != $right);
        } else {
            assert_ne!($left, $right);
        }
    );
}

#[macro_export]
macro_rules! unreachable {
    () => (
        if cfg!(crux) {
            $crate::crucible::crucible_assert_unreachable!();
        } else {
            unreachable!();
        }
    );
}

macro_rules! nondet_impls {
    ($($crucible_ty:ident, $value:expr;)*) => {
        #[macro_export]
        macro_rules! nondet {
            $(
                ($value) => {
                    if cfg!(crux) {
                        $crate::crucible::$crucible_ty(concat!("symb_", line!(), "_", column!()))
                    } else {
                        $value
                    }
                };
            )*
        }
    };
}

nondet_impls! {
    crucible_u32, 1u32;
    crucible_u32, 2u32;
    crucible_u32, 3u32;
    crucible_u32, 4u32;
    crucible_u32, 5u32;
    crucible_u32, 6u32;
    crucible_u32, 7u32;
    crucible_u32, 8u32;

    crucible_i32, 1i32;
    crucible_i32, 2i32;
    crucible_i32, 3i32;
    crucible_i32, 4i32;
    crucible_i32, 5i32;
    crucible_i32, 6i32;
    crucible_i32, 7i32;
    crucible_i32, 8i32;

    crucible_u64, 1u64;
    crucible_u64, 2u64;
    crucible_u64, 3u64;
    crucible_u64, 4u64;
    crucible_u64, 5u64;
    crucible_u64, 6u64;
    crucible_u64, 7u64;
    crucible_u64, 8u64;

    crucible_i64, 1i64;
    crucible_i64, 2i64;
    crucible_i64, 3i64;
    crucible_i64, 4i64;
    crucible_i64, 5i64;
    crucible_i64, 6i64;
    crucible_i64, 7i64;
    crucible_i64, 8i64;
}
